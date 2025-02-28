//
//  ViewController.swift
//  Equity
//
//  Created by ANDELA on 25/02/2025.
//

import UIKit
import SwiftUI
import Combine

class CoinListViewController: UIViewController, UITableViewDelegate {
  // MARK: - Properties
  private var bottomSheetHeightConstraint: NSLayoutConstraint!
  private let filterViewModel = FilterViewModel()
  private var favoriteCryptoIds: Set<String> = []
  private let viewModel: CoinListViewModel
  private var popupHostingController: UIHostingController<PopupView>?
  private var popupIsVisible = false
  private var cancellables = Set<AnyCancellable>()

  // MARK: - UI Components
  private lazy var tableView: UITableView = {
      let tableView = UITableView()
      tableView.tableHeaderView = UIView()
      tableView.translatesAutoresizingMaskIntoConstraints = false
      return tableView
  }()

  private lazy var headerView: HeaderView = {
      let view = HeaderView()
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
  }()
  
  init(viewModel: CoinListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
      configureTableView()
      setupHeaderView()
      bindViewModel()
  }

  // MARK: - Setup Methods
  private func setupUI() {
      view.addSubview(headerView)
      view.addSubview(tableView)
      setupConstraints()
  }

  private func configureTableView() {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.allowsSelection = true
      registerCustomCell()
  }

  private func setupHeaderView() {
      headerView.filterAction = { [weak self] in
          self?.presentFilterSheet()
      }
  }
  
  private func bindViewModel() {
    viewModel.$coins
      .sink { [weak self] _ in
        self?.tableView.reloadData()
      }
      .store(in: &cancellables)
    
    viewModel.$isLoading
      .sink { [weak self] isLoading in
        if !isLoading { self?.tableView.reloadData() }
      }
      .store(in: &cancellables)
  }

  private func setupConstraints() {
      NSLayoutConstraint.activate([
          headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
          headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),          
          tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
          tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
  }

  private func registerCustomCell() {
      tableView.register(CoinViewCell.self, forCellReuseIdentifier: CoinViewCell.identifier)
  }
  // MARK: - UITableView Delegate (Navigation)
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedCrypto = viewModel.coins[indexPath.row]
    navigateToCryptoDetail(with: selectedCrypto)
  }
}


extension CoinListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CoinViewCell.identifier) as? CoinViewCell {
      let coin = viewModel.coins[indexPath.row]
      cell.configureCell(model: coin)
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.coins.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  // Add swipe action for favoring
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let cryptoId = "Qwsogvtv82FCd_\(indexPath.row)" // Example ID
    
    let favoriteAction = UIContextualAction(style: .normal, title: favoriteCryptoIds.contains(cryptoId) ? "Unfavorite" : "Favorite") { [weak self] (action, view, completion) in
      guard let self = self else { return }
      if self.favoriteCryptoIds.contains(cryptoId) {
        self.favoriteCryptoIds.remove(cryptoId)
      } else {
        self.favoriteCryptoIds.insert(cryptoId)
      }
      
      // Show pop-up message
      let message = !favoriteCryptoIds.contains(cryptoId) ? NSLocalizedString("removed_from_favorites", comment: "") : NSLocalizedString("added_to_favorites", comment: "")

      self.showPopup(message: message)
      
      // Update the cell's favorite icon
      if let cell = tableView.cellForRow(at: indexPath) as? CoinViewCell {
        //cell.updateFavoriteIcon(isFavorite:
        //self.favoriteCryptoIds.contains(cryptoId))
      }
      completion(true)
    }
    
    // Set favorite icon (using SF Symbols)
    favoriteAction.image = UIImage(systemName: favoriteCryptoIds.contains(cryptoId) ? "star.fill" : "star")
    favoriteAction.backgroundColor = favoriteCryptoIds.contains(cryptoId) ? .systemYellow : .systemGray
    
    
    let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
    configuration.performsFirstActionWithFullSwipe = true
    return configuration
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let threshold = 5 // Fetch 5 rows before the end
    if indexPath.row == viewModel.coins.count - threshold {
      viewModel.fetchNextPage()
    }
  }
}

extension CoinListViewController {
    private func presentFilterSheet() {
          let filterVC = FilterViewController()
          if let sheet = filterVC.sheetPresentationController {
              sheet.detents = [
                .medium()
              ]
              sheet.prefersGrabberVisible = true
              sheet.preferredCornerRadius = 20
          }
          
          present(filterVC, animated: true, completion: nil)
      }
}

extension CoinListViewController {
  // MARK: - Navigation using UIHostingController
  private func navigateToCryptoDetail(with crypto: CryptoItem) {
    let detailView = CryptoDetailView(crypto: crypto)
    let hostingController = UIHostingController(rootView: detailView)
    hostingController.navigationItem.hidesBackButton = true

    navigationController?.pushViewController(hostingController, animated: true)
  }
  
  private func showPopup(message: String) {
    if popupIsVisible { return }
    popupIsVisible = true
    let popupView = PopupView(message: message, isVisible: .constant(true))
    let hostingController = UIHostingController(rootView: popupView)
    hostingController.view.backgroundColor = .clear
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    
    addChild(hostingController)
    view.addSubview(hostingController.view)
    hostingController.didMove(toParent: self)
    
    NSLayoutConstraint.activate([
      hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      hostingController.view.heightAnchor.constraint(equalToConstant: 100)
    ])
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      hostingController.willMove(toParent: nil)
      hostingController.view.removeFromSuperview()
      hostingController.removeFromParent()
      self.popupIsVisible = false
    }
  }
}

