//
//  CoinListViewModelProtocol.swift
//  Equity
//
//  Created by ANDELA on 01/03/2025.
//

import Foundation
import Combine

protocol CoinListViewModelProtocol: AnyObject, ObservableObject {
    // MARK: - Published Properties
    var coins: [CryptoItem] { get }
    var filteredCoins: [CryptoItem] { get }
    var isLoading: Bool { get }
    var hasMorePages: Bool { get }
    var searchText: String { get set }
    var showNoResults: Bool { get }
    var errorMessage: String? { get }
    var favoriteCoins: [CryptoItem] { get }
    
    // MARK: - Methods
    func fetchNextPage()
    func resetSearch()
    func retryFetch()
    func toggleFavorite(cryptoId: String, coin: CryptoItem) async
    func isFavorite(cryptoId: String) -> Bool
    func filterByHighestPrice()
    func filterByBest24HourPerformance()
}
