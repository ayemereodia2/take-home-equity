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

protocol FavoritesRepository {
    func addFavorite(crypto: CryptoItem) throws
    func removeFavorite(cryptoId: String) throws
    func isFavorite(cryptoId: String) throws -> Bool
    func getAllFavorites() throws -> [CryptoItem]
}

class UserDefaultsFavoritesRepository: FavoritesRepository {
    private let userDefaults: UserDefaults
    private let queue = DispatchQueue(label: "com.cryptoapp.favorites", attributes: .concurrent) // Thread-safe access

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func addFavorite(crypto: CryptoItem) throws {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            do {
                let data = try JSONEncoder().encode(crypto) // Serialize CryptoItem
                self.userDefaults.set(data, forKey: crypto.id) // Store in UserDefaults
            } catch {
                print("Error encoding CryptoItem: \(error)")
            }
        }
    }
    
    func removeFavorite(cryptoId: String) throws {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            if self.userDefaults.object(forKey: cryptoId) == nil {
                print("CryptoItem with ID \(cryptoId) not found.")
                return
            }
            self.userDefaults.removeObject(forKey: cryptoId)
        }
    }
    
    func isFavorite(cryptoId: String) throws -> Bool {
        return queue.sync {
            guard userDefaults.data(forKey: cryptoId) != nil else {
                return false
            }
            return true
        }
    }
    
    func getAllFavorites() throws -> [CryptoItem] {
        return queue.sync {
            userDefaults.dictionaryRepresentation()
                .compactMap { key, value in
                    guard let data = value as? Data else { return nil }
                    do {
                        return try JSONDecoder().decode(CryptoItem.self, from: data)
                    } catch {
                        print("Error decoding CryptoItem: \(error)")
                        return nil
                    }
                }
        }
    }
}

// Custom error type for potential failures
enum FavoritesError: Error {
    case storageFailure
    case decodingFailure
}
