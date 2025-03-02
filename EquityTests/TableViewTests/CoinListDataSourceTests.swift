//
//  CoinListDataSourceTests.swift
//  EquityTests
//
//  Created by ANDELA on 01/03/2025.
//

import XCTest
@testable import Equity

final class CoinListDataSourceTests: XCTestCase {
  var dataSource: CoinListDataSource!
  var viewModel: MockCoinListViewModel!
  
  override func setUp() {
    viewModel = MockCoinListViewModel(networkService: MockNetworkService())
      dataSource = CoinListDataSource(viewModel: viewModel)
  }
  
  func testNumberOfRows() {
      viewModel.filteredCoins = [CryptoItem.mock(), CryptoItem.mock()]
      let tableView = UITableView()
      XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection: 0), 2)
  }
}
