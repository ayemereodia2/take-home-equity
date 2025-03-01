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
  private let favoriteCointViewModel: FavoritesCoinViewModel
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
  
  private lazy var noResultsLabel: UILabel = {
      let label = UILabel()
      label.text = "No results found"
      label.textAlignment = .center
      label.textColor = .gray
      label.isHidden = true
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
  }()
  
  init(viewModel: CoinListViewModel, favoriteCointViewModel: FavoritesCoinViewModel) {
    self.viewModel = viewModel
    self.favoriteCointViewModel = favoriteCointViewModel
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
      view.addSubview(noResultsLabel)
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
    
    headerView.searchAction = { [weak self] queryString in
      self?.viewModel.searchText = queryString
    }
    
    headerView.cancelAction = { [weak self] in
      self?.viewModel.resetSearch()
    }
  }
  
  private func bindViewModel() {
    viewModel.$filteredCoins
      .sink { [weak self] _ in
        self?.tableView.reloadData()
      }
      .store(in: &cancellables)
    
    viewModel.$isLoading
      .sink { [weak self] isLoading in
        if !isLoading { self?.tableView.reloadData() }
      }
      .store(in: &cancellables)
    
    viewModel.$showNoResults
      .sink { [weak self] showNoResults in
        self?.noResultsLabel.isHidden = !showNoResults
      }
      .store(in: &cancellables)
    
    viewModel.$errorMessage
      .sink { [weak self] errorMessage in
        guard let self = self else { return }
        if let message = errorMessage {
          showPopup(message: message, messageType: .error)
          self.tableView.isHidden = true
        } else {
          self.tableView.isHidden = false
        }
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
          tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          
          noResultsLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
          noResultsLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
          noResultsLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 16),
          noResultsLabel.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -16)
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
    guard indexPath.row < viewModel.filteredCoins.count else {
      disableTableView()
      return UITableViewCell()
    }
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: CoinViewCell.identifier) as? CoinViewCell {
      let coin = viewModel.filteredCoins[indexPath.row]
      enableTableView()
      cell.configureCell(model: coin)
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.filteredCoins.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  
  // Add swipe action for favoring
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let coinItem = viewModel.filteredCoins[indexPath.row]
    let cryptoId = coinItem.id
    let coinName = coinItem.symbol
    let isFavorite = viewModel.isFavorite(cryptoId: cryptoId)
    
    let favoriteAction = UIContextualAction(style: .normal, title: isFavorite ? "Unfavorite" : "Favorite") { [weak self] (_, _, completion) in
      guard let self = self else {
        completion(false)
        return
      }
      
      Task {
        await self.viewModel.toggleFavorite(cryptoId: cryptoId, coin: coinItem)
        
        // Ensure UI updates correctly by reloading the row
        DispatchQueue.main.async {
          tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        // Show a popup message
        let message = self.viewModel.isFavorite(cryptoId: cryptoId) ?
        NSLocalizedString("added_to_favorites", comment: "") :
        NSLocalizedString("removed_from_favorites", comment: "")
        self.showPopup(message: "\(coinName) \(message)", messageType: .info)
        
        completion(true)
      }
    }
    
    favoriteAction.image = UIImage(systemName: isFavorite ? "star.fill" : "star")
    favoriteAction.backgroundColor = isFavorite ? .systemYellow : .systemGray
    
    let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
    configuration.performsFirstActionWithFullSwipe = true
    return configuration
  }

  
  private func disableTableView() {
    tableView.separatorStyle = .none
    tableView.allowsSelection = false
  }
  
  private func enableTableView() {
    tableView.separatorStyle = .singleLine
    tableView.allowsSelection = true
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let threshold = 5 // Fetch 5 rows before the end
    if indexPath.row == viewModel.filteredCoins.count - threshold {
      viewModel.fetchNextPage()
    }
  }
}

extension CoinListViewController {
  private func presentFilterSheet() {
    let filterVC = FilterViewController()
    if let sheet = filterVC.sheetPresentationController {
      sheet.detents = [.medium()]
      sheet.prefersGrabberVisible = true
      sheet.preferredCornerRadius = 20
    }
    
    filterVC.highestPriceAction = { [weak self] in
      // filter and reload table
    }
    
    filterVC.best24HourAction = { [weak self] in
      // filter and reload table
    }
    
    present(filterVC, animated: true, completion: nil)
  }
}

extension CoinListViewController {
  // MARK: - Navigation using UIHostingController
  private func navigateToCryptoDetail(with crypto: CryptoItem) {
    
    let detailView = CryptoDetailView(
      crypto: crypto,
      viewModel: favoriteCointViewModel
    )
    
    let hostingController = UIHostingController(rootView: detailView)
    hostingController.navigationItem.hidesBackButton = true

    navigationController?.pushViewController(hostingController, animated: true)
  }
  
  private func showPopup(message: String, messageType: MessageType) {
    if popupIsVisible { return }
    popupIsVisible = true
    
    let popupView = PopupView(
      message: message,
      isVisible: .constant(true),
      messageType: messageType
    )
    
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

enum MessageType {
  case error
  case warning
  case info
}
