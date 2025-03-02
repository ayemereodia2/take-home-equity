//
//  FavoritesCoinViewModelTests.swift
//  EquityTests
//
//  Created by ANDELA on 01/03/2025.
//

import XCTest
import Combine
@testable import Equity

final class FavoritesCoinViewModelTests: XCTestCase {
    var viewModel: FavoritesCoinViewModel!
    var mockFavoritesRepository: MockFavoritesRepository!

    override func setUp() {
        super.setUp()
        mockFavoritesRepository = MockFavoritesRepository()
        viewModel = FavoritesCoinViewModel(favoritesRepository: mockFavoritesRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockFavoritesRepository = nil
        super.tearDown()
    }

    func testLoadFavorites_Success() async {
        // Arrange
      let mockFavorites = CryptoItem.mockList()
        mockFavoritesRepository.stubbedFavorites = mockFavorites
        
        // Act
        await viewModel.loadFavorites()
        
        // Assert
        XCTAssertEqual(viewModel.favoriteCoins.count, 2)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(mockFavoritesRepository.getAllFavoritesCalled)
    }

    func testLoadFavorites_Failure() async {
        // Arrange
        mockFavoritesRepository.shouldThrowError = true
        
        // Act
        await viewModel.loadFavorites()
        
        // Assert
        XCTAssertEqual(viewModel.favoriteCoins.count, 0)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(mockFavoritesRepository.getAllFavoritesCalled)
    }

    func testToggleFavorite_AddsFavorite() async {
        // Arrange
        let crypto = CryptoItem.mock()
        mockFavoritesRepository.stubbedIsFavorite = false
        
        // Act
        await viewModel.toggleFavorite(crypto: crypto)
        
        // Assert
        XCTAssertTrue(mockFavoritesRepository.addFavoriteCalled)
        XCTAssertTrue(mockFavoritesRepository.isFavoriteCalled)
    }

    func testToggleFavorite_RemovesFavorite() async {
        // Arrange
        let crypto = CryptoItem.mock()
        mockFavoritesRepository.stubbedIsFavorite = true
        
        // Act
        await viewModel.toggleFavorite(crypto: crypto)
        
        // Assert
        XCTAssertTrue(mockFavoritesRepository.removeFavoriteCalled)
        XCTAssertTrue(mockFavoritesRepository.isFavoriteCalled)
    }

    func testToggleFavorite_Failure() async {
        // Arrange
        let crypto = CryptoItem.mock()
        mockFavoritesRepository.shouldThrowError = true
        
        // Act
        await viewModel.toggleFavorite(crypto: crypto)
        
        // Assert
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testRemoveFavorite_Success() async {
        // Arrange
        let cryptoId = "bitcoin"
        
        // Act
        await viewModel.removeFavorite(cryptoId: cryptoId)
        
        // Assert
        XCTAssertTrue(mockFavoritesRepository.removeFavoriteCalled)
    }

    func testRemoveFavorite_Failure() async {
        // Arrange
        let cryptoId = "bitcoin"
        mockFavoritesRepository.shouldThrowError = true
        
        // Act
        await viewModel.removeFavorite(cryptoId: cryptoId)
        
        // Assert
        XCTAssertNotNil(viewModel.errorMessage)
    }
}


