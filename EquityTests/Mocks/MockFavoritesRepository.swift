//
//  MockFavoritesRepository.swift
//  EquityTests
//
//  Created by ANDELA on 01/03/2025.
//

import Foundation
@testable import Equity

final class MockFavoritesRepository: FavoritesRepository {
    var stubbedFavorites: [CryptoItem] = []
    var stubbedIsFavorite: Bool = false
    var shouldThrowError = false

    private(set) var getAllFavoritesCalled = false
    private(set) var isFavoriteCalled = false
    private(set) var addFavoriteCalled = false
    private(set) var removeFavoriteCalled = false

    func getAllFavorites() throws -> [CryptoItem] {
        getAllFavoritesCalled = true
        if shouldThrowError { throw NSError(domain: "TestError", code: 1, userInfo: nil) }
        return stubbedFavorites
    }
    
    func isFavorite(cryptoId: String) throws -> Bool {
        isFavoriteCalled = true
        if shouldThrowError { throw NSError(domain: "TestError", code: 1, userInfo: nil) }
        return stubbedIsFavorite
    }
    
    func addFavorite(crypto: CryptoItem) throws {
        addFavoriteCalled = true
        if shouldThrowError { throw NSError(domain: "TestError", code: 1, userInfo: nil) }
        stubbedFavorites.append(crypto)
    }
    
    func removeFavorite(cryptoId: String) throws {
        removeFavoriteCalled = true
        if shouldThrowError { throw NSError(domain: "TestError", code: 1, userInfo: nil) }
        stubbedFavorites.removeAll { $0.id == cryptoId }
    }
}
