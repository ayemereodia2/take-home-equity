//
//  CoinListDelegateTests.swift
//  EquityTests
//
//  Created by ANDELA on 01/03/2025.
//

import XCTest
@testable import Equity
import Combine

final class CoinListDelegateTests: XCTestCase {
  var delegate: CoinListDelegate!
  var viewController: CoinListViewController!
  var viewModel: MockCoinListViewModel!
  var favoriteCoinViewModel: MockFavoritesCoinViewModel!
  var tableView: UITableView!

  override func setUp() {
    super.setUp()
    setupViewController()
    setupTableView()
  }

  override func tearDown() {
    viewModel = nil
    favoriteCoinViewModel = nil
    viewController = nil
    delegate = nil
    tableView = nil
    super.tearDown()
  }

  func setupViewController() {
    viewModel = MockCoinListViewModel(networkService: MockNetworkService())
    favoriteCoinViewModel = MockFavoritesCoinViewModel()
    let coordinator = CoinListCoordinator(navigationController: UINavigationController())
    let headerViewModel = HeaderViewModel()
    
    viewController = CoinListViewController(
      viewModel: viewModel,
      favoriteCoinViewModel: favoriteCoinViewModel,
      coordinator: coordinator,
      headerViewModel: headerViewModel
    )
    delegate = CoinListDelegate(viewController: viewController)
    
    viewModel.filteredCoins = createMockCryptoItems()
  }
  
  func setupTableView() {
    tableView = UITableView()
    tableView.delegate = delegate
  }

  func createMockCryptoItems() -> [CryptoItem] {
    return [
      CryptoItem(id: "bitcoin", name: "Bitcoin", price: 50000, marketCap: 1000000, volume24h: 100000, symbol: "BTC", supply: 21000000, iconUrl: nil, change: "+5%", sparkLine: nil),
      CryptoItem(id: "ethereum", name: "Ethereum", price: 3000, marketCap: 500000, volume24h: 50000, symbol: "ETH", supply: 100000000, iconUrl: nil, change: "+3%", sparkLine: nil)
    ]
  }

  func testDidSelectRow_NavigatesToDetailView() {
    let indexPath = IndexPath(row: 0, section: 0)
    delegate.tableView(tableView, didSelectRowAt: indexPath)
    // Assert navigation logic if applicable
  }
  
  func testHeightForRow_ReturnsAutomaticDimension() {
    let indexPath = IndexPath(row: 0, section: 0)
    XCTAssertEqual(delegate.tableView(tableView, heightForRowAt: indexPath), UITableView.automaticDimension)
  }
  
  func testSwipeActions_TogglesFavoriteState() {
    let indexPath = IndexPath(row: 0, section: 0)
    let actions = delegate.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
    
    XCTAssertNotNil(actions)
    XCTAssertEqual(actions?.actions.count, 1)
    XCTAssertEqual(actions?.actions.first?.title, viewModel.isFavorite(cryptoId: "bitcoin") ? "Unfavorite" : "Favorite")
  }
  
  func testWillDisplayCell_LoadsNextPageWhenNearBottom() {
    let spyViewModel = SpyCoinListViewModel(networkService: MockNetworkService())
    viewController.viewModel = spyViewModel
    delegate = CoinListDelegate(viewController: viewController)
    
    let indexPath = IndexPath(row: spyViewModel.filteredCoins.count - 5, section: 0)
    delegate.tableView(tableView, willDisplay: UITableViewCell(), forRowAt: indexPath)
    
    XCTAssertTrue(spyViewModel.fetchNextPageCalled, "fetchNextPage should be called when near the end of the list")
  }
}

class SpyCoinListViewModel: CoinListViewModel {
  var fetchNextPageCalled = false
  override func fetchNextPage() { fetchNextPageCalled = true }
}
