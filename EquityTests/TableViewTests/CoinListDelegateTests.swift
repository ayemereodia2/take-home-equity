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
    
    viewModel = MockCoinListViewModel(networkService: MockNetworkService())
    favoriteCoinViewModel = MockFavoritesCoinViewModel()
    viewController = CoinListViewController(viewModel: viewModel, favoriteCoinViewModel: favoriteCoinViewModel)
    delegate = CoinListDelegate(viewController: viewController)
    tableView = UITableView()
    tableView.delegate = delegate
    
    // Add mock data for testing
    viewModel.filteredCoins = [
      CryptoItem(id: "bitcoin", name: "Bitcoin", price: 50000, marketCap: 1000000, volume24h: 100000, symbol: "BTC", supply: 21000000, iconUrl: nil, change: "+5%", sparkLine: nil),
      CryptoItem(id: "ethereum", name: "Ethereum", price: 3000, marketCap: 500000, volume24h: 50000, symbol: "ETH", supply: 100000000, iconUrl: nil, change: "+3%", sparkLine: nil)
    ]
  }
  
  override func tearDown() {
    viewModel = nil
    favoriteCoinViewModel = nil
    viewController = nil
    delegate = nil
    tableView = nil
    super.tearDown()
  }
  
  func testDidSelectRow_NavigatesToDetailView() {
    let indexPath = IndexPath(row: 0, section: 0)
    
    // Act
    delegate.tableView(tableView, didSelectRowAt: indexPath)
    
  }
  
  func testHeightForRow_ReturnsAutomaticDimension() {
    let indexPath = IndexPath(row: 0, section: 0)
    let height = delegate.tableView(tableView, heightForRowAt: indexPath)
    
    XCTAssertEqual(height, UITableView.automaticDimension)
  }
  
  func testSwipeActions_TogglesFavoriteState() {
    let indexPath = IndexPath(row: 0, section: 0)
    
    // Act
    let actions = delegate.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
    
    // Assert
    XCTAssertNotNil(actions)
    XCTAssertEqual(actions?.actions.count, 1)
    
    let favoriteAction = actions?.actions.first
    XCTAssertNotNil(favoriteAction)
    XCTAssertEqual(favoriteAction?.title, viewModel.isFavorite(cryptoId: "bitcoin") ? "Unfavorite" : "Favorite")
  }
  
  func testWillDisplayCell_LoadsNextPageWhenNearBottom() {
    // Use the spy instead of the regular mock
    let spyViewModel = SpyCoinListViewModel(
      networkService: MockNetworkService()
    )
    viewController = CoinListViewController(
      viewModel: spyViewModel,
      favoriteCoinViewModel: favoriteCoinViewModel
    )
    delegate = CoinListDelegate(viewController: viewController)
    
    let indexPath = IndexPath(row: spyViewModel.filteredCoins.count - 5, section: 0)
    
    // Act
    delegate.tableView(tableView, willDisplay: UITableViewCell(), forRowAt: indexPath)
    
    // Assert
    XCTAssertTrue(spyViewModel.fetchNextPageCalled, "fetchNextPage should be called when near the end of the list")
  }
  
}

class SpyCoinListViewModel: CoinListViewModel {
  var fetchNextPageCalled = false
  
  override func fetchNextPage() {
    fetchNextPageCalled = true
  }
}
