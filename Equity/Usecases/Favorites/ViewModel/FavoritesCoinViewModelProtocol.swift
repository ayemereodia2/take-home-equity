//
//  FavoritesCoinViewModelProtocol.swift
//  Equity
//
//  Created by ANDELA on 01/03/2025.
//

import Foundation
import Combine

protocol FavoritesCoinViewModelProtocol: ObservableObject {
    // MARK: - Published Properties
    var favoriteCoins: [CryptoItem] { get }
    var errorMessage: String? { get }
    
    // MARK: - Methods
    func loadFavorites() async
    func reloadFavorites() async
    func toggleFavorite(crypto: CryptoItem?) async
    func removeFavorite(cryptoId: String) async
}
