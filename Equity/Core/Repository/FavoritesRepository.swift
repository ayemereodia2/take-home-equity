//
//  FavoritesRepository.swift
//  Equity
//
//  Created by ANDELA on 28/02/2025.
//

import Foundation
/*
 Since UserDefaults operations (set, array(forKey:)) are synchronous, we wrap them in Task to provide an async interface. The try await Task { ... }.value syntax simulates asynchronous execution and allows throwing errors, aligning with the protocol.

 */

protocol Repository {
    associatedtype Item: Codable & Identifiable
    func add(_ item: Item) throws
    func remove(id: String) throws
    func contains(id: String) throws -> Bool
    func getAll() throws -> [Item]
}


// Custom error type
enum RepositoryError: Error {
    case storageFailure
    case decodingFailure
}


protocol FavoritesRepository {
    func addFavorite(crypto: CryptoItem) throws
    func removeFavorite(cryptoId: String) throws
    func isFavorite(cryptoId: String) throws -> Bool
    func getAllFavorites() throws -> [CryptoItem]
}

class UserDefaultsFavoritesRepository: FavoritesRepository {
    
  private let repository: GenericUserDefaultsRepository<CryptoItem>


    init(userDefaults: UserDefaults = .standard) {
      self.repository = GenericUserDefaultsRepository(userDefaults: userDefaults, storageNamespace: "favorites")
    }
    
    func addFavorite(crypto: CryptoItem) throws {
      try repository.add(crypto)
    }
    
    func removeFavorite(cryptoId: String) throws {
      try repository.remove(id: cryptoId)
    }
    
    func isFavorite(cryptoId: String) throws -> Bool {
      try repository.contains(id: cryptoId)
    }
    
    func getAllFavorites() throws -> [CryptoItem] {
      try repository.getAll()
    }
}

// Custom error type for potential failures
enum FavoritesError: Error {
    case storageFailure
    case decodingFailure
}
