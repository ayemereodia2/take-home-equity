//
//  CoinListViewModelTests.swift
//  EquityTests
//
//  Created by ANDELA on 01/03/2025.
//

import XCTest
import Combine
@testable import Equity

class CoinListViewModelTests: XCTestCase {

    var viewModel: CoinListViewModel!
    var mockNetworkService: MockNetworkService!
    var mockFavoritesRepository: MockFavoritesRepository!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockFavoritesRepository = MockFavoritesRepository()
      
        viewModel = CoinListViewModel(
          networkService: mockNetworkService,
          favoritesRepository: mockFavoritesRepository
        )
    }

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        viewModel = nil
        mockNetworkService = nil
        mockFavoritesRepository = nil
        super.tearDown()
    }

    // MARK: - Fetching Coins
    
    func testFetchNextPage_Success() {
        // Arrange
        let response = CoinResponse.mock()
        mockNetworkService.mockCoinResponse = response
        
        let expectation = XCTestExpectation(description: "Fetch coins successfully")

        // Act
        viewModel.isLoading = false
        viewModel.fetchNextPage()

        // Assert

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.coins.count, 2)
            XCTAssertEqual(self.viewModel.filteredCoins.count, 2)
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchNextPage_Failure() {
        // Arrange
        mockNetworkService.stubbedFetchCoinsResult = Fail(error: NetworkError.requestFailed(NSError(domain: "", code: -1, userInfo: nil)))
            .eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "Fetch coins failed")

        // Act
        viewModel.fetchNextPage()

        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.viewModel.coins.isEmpty)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Search Filtering
    
    func testSearch_FilterCoins() {
        // Arrange
        viewModel.coins = CryptoItem.mockList()
        
        // Act
        viewModel.searchText = "bit"
      // wait for deboucing of text input
      let expectation = XCTestExpectation(description: "Wait for debounce")
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
        expectation.fulfill()
      }
      wait(for: [expectation], timeout: 1.0)

        // Assert
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
    }

    func testSearch_NoResults() {
        // Arrange
        viewModel.coins = CryptoItem.mockList()
        
        // Act
        viewModel.searchText = "xrp"

        // Assert
        XCTAssertTrue(viewModel.filteredCoins.isEmpty)
        XCTAssertTrue(viewModel.showNoResults)
    }

    func testResetSearch() {
        // Arrange
        viewModel.searchText = "bitcoin"

        // Act
        viewModel.resetSearch()

        // Assert
        XCTAssertEqual(viewModel.searchText, "")
    }

    // MARK: - Sorting
    
    func testFilterByHighestPrice() {
        // Arrange
        viewModel.coins = CryptoItem.mockList()
        
        // Act
        viewModel.filterByHighestPrice()

        // Assert
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
        XCTAssertEqual(viewModel.filteredCoins.last?.name, "Dogecoin")
    }

    func testFilterByBest24HourPerformance() {
        // Arrange
      viewModel.coins = CryptoItem.mockList()
        
        // Act
        viewModel.filterByBest24HourPerformance()

        // Assert
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
        XCTAssertEqual(viewModel.filteredCoins.last?.name, "Dogecoin")
    }

    // MARK: - Favorites Management
    
    func testToggleFavorite_AddsAndRemovesFavorite() async {
        // Arrange
        let coin = CryptoItem.mock()
        
        // Act - Add to favorites
        await viewModel.toggleFavorite(cryptoId: "1", coin: coin)

        // Assert
      XCTAssertTrue(mockFavoritesRepository.addFavoriteCalled)

        // Act - Remove from favorites
      mockFavoritesRepository.stubbedIsFavorite = true
        await viewModel.toggleFavorite(cryptoId: "1", coin: coin)

        // Assert
      XCTAssertTrue(mockFavoritesRepository.removeFavoriteCalled)
    }
}
