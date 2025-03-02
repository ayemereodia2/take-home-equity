//
//  GenericUserDefaultsRepository.swift
//  Equity
//
//  Created by ANDELA on 02/03/2025.
//

import Foundation

class GenericUserDefaultsRepository<T: Codable & Identifiable>: Repository where T.ID == String {
    private let userDefaults: UserDefaults
    private let queue: DispatchQueue
    private let storageKeyPrefix: String
    
    init(
        userDefaults: UserDefaults = .standard,
        storageNamespace: String
    ) {
        self.userDefaults = userDefaults
        self.storageKeyPrefix = "com.cryptoapp.\(storageNamespace)"
        self.queue = DispatchQueue(label: storageKeyPrefix, attributes: .concurrent)
    }
    
    func add(_ item: T) throws {
        try queue.sync(flags: .barrier) {
            let data = try JSONEncoder().encode(item)
            userDefaults.set(data, forKey: key(for: item.id))
        }
    }
    
    func remove(id: String) throws {
        queue.async(flags: .barrier) {
            self.userDefaults.removeObject(forKey: self.key(for: id))
        }
    }
    
    func contains(id: String) throws -> Bool {
        queue.sync {
            userDefaults.data(forKey: key(for: id)) != nil
        }
    }
    
    func getAll() throws -> [T] {
        queue.sync {
            userDefaults.dictionaryRepresentation()
                .filter { $0.key.hasPrefix(self.storageKeyPrefix) }
                .compactMap { _, value in
                    guard let data = value as? Data else { return nil }
                    return try? JSONDecoder().decode(T.self, from: data)
                }
        }
    }
    
    // MARK: - Helpers
    private func key(for id: String) -> String {
        "\(storageKeyPrefix).\(id)"
    }
}
