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
    let coordinator: CoinListCoordinator
    
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
      let noResultsText = NSLocalizedString("no_results_found", comment: "")
        let label = UILabel()
        label.text = noResultsText
        label.textAlignment = .center
        label.textColor = .gray
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
  
  private lazy var loadingView: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.color = .gray
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.hidesWhenStopped = true
    return activityIndicator
  }()
    
    // MARK: - DataSource and Delegate
    private var dataSource: CoinListDataSource!
    private var delegate: CoinListDelegate!
    
    // MARK: - Initializer
    init(
      viewModel: CoinListViewModel,
      favoriteCoinViewModel: FavoritesCoinViewModel, coordinator: CoinListCoordinator
    ) {
        self.viewModel = viewModel
        self.favoriteCoinViewModel = favoriteCoinViewModel
        self.coordinator = coordinator
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
        view.addSubview(loadingView)
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
          guard let self = self else { return }
          if isLoading {
            self.loadingView.startAnimating()
            self.tableView.isHidden = true
            self.noResultsLabel.isHidden = true
          } else {
            self.loadingView.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.reloadData()
          }
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
              PopupManager.showPopup(on: self, message: message, messageType: .error)
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
            noResultsLabel.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -16),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func registerCustomCell() {
        tableView.register(CoinViewCell.self, forCellReuseIdentifier: CoinViewCell.identifier)
    }
}

extension CoinListViewController {
  func presentFilterSheet() {
    coordinator.presentFilterSheet(from: self, viewModel: viewModel)
  }
  private func reloadCoins() {
    viewModel.fetchNextPage()
  }
}
