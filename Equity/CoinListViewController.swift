//
//  ViewController.swift
//  Equity
//
//  Created by ANDELA on 25/02/2025.
//

import UIKit
import SwiftUI
import Combine


class CoinListViewController: UIViewController {
    // MARK: - Properties
    private var bottomSheetHeightConstraint: NSLayoutConstraint!
    private var favoriteCryptoIds: Set<String> = []
    let viewModel: CoinListViewModel
    let favoriteCoinViewModel: FavoritesCoinViewModel
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
    
    // MARK: - DataSource and Delegate
    private var dataSource: CoinListDataSource!
    private var delegate: CoinListDelegate!
    
    // MARK: - Initializer
    init(viewModel: CoinListViewModel, favoriteCoinViewModel: FavoritesCoinViewModel) {
        self.viewModel = viewModel
        self.favoriteCoinViewModel = favoriteCoinViewModel
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
        dataSource = CoinListDataSource(viewModel: viewModel)
        delegate = CoinListDelegate(viewController: self)
        
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.allowsSelection = true
        registerCustomCell()
    }
    
    private func setupHeaderView() {
        headerView.filterAction = { [weak self] in
            self?.presentFilterSheet()
        }
        
        headerView.allAssetsAction = { [weak self] in
            self?.reloadCoins()
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
                guard let self = self, let message = errorMessage else { return }
                self.showPopup(message: message, messageType: .error)
                self.tableView.isHidden = true
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
}


extension CoinListViewController {
  private func presentFilterSheet() {
    let filterVC = FilterViewController()
    if let sheet = filterVC.sheetPresentationController {
      sheet.detents = [.medium()]
      sheet.prefersGrabberVisible = true
      sheet.preferredCornerRadius = 20
      sheet.selectedDetentIdentifier = .large
    }
    
    filterVC.highestPriceAction = { [weak self] in
      self?.viewModel.filterByHighestPrice()
      self?.tableView.reloadData()
      filterVC.dismiss(animated: true)
    }
    
    filterVC.best24HourAction = { [weak self] in
      self?.viewModel.filterByBest24HourPerformance()
      self?.tableView.reloadData()
      filterVC.dismiss(animated: true)
    }
    
    present(filterVC, animated: true, completion: nil)
  }
  
  private func reloadCoins() {
    viewModel.fetchNextPage()
  }
}

extension CoinListViewController {
  // MARK: - Navigation using UIHostingController
  func navigateToCryptoDetail(with crypto: CryptoItem) {
    let detailView = CryptoDetailView(
      crypto: crypto,
      viewModel: favoriteCoinViewModel
    )
    
    let hostingController = UIHostingController(rootView: detailView)
    hostingController.navigationItem.hidesBackButton = true

    navigationController?.pushViewController(hostingController, animated: true)
  }
  
  func showPopup(message: String, messageType: MessageType) {
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
