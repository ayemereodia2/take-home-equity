//
//  MockCoinListViewModel.swift
//  EquityTests
//
//  Created by ANDELA on 01/03/2025.
//

import Foundation
@testable import Equity
import Combine
import SwiftUI

final class MockCoinListViewModel: CoinListViewModel {

  override func fetchNextPage() {
        coins = [CryptoItem.mock()]
        filteredCoins = coins
    }
    
  override func resetSearch() {
        searchText = ""
        filteredCoins = coins
    }
    
  override func retryFetch() {
        coins = [CryptoItem.mock()]
        filteredCoins = coins
    }
    
  override func toggleFavorite(cryptoId: String, coin: CryptoItem) async {
        if favoriteCoins.contains(where: { $0.id == cryptoId }) {
          favoriteCoins.removeAll { $0.id == cryptoId }
        } else {
          favoriteCoins.append(coin)
        }
    }
    
    override func isFavorite(cryptoId: String) -> Bool {
      favoriteCoins.contains(where: { $0.id == cryptoId })
    }
    
  override func filterByHighestPrice() {
        filteredCoins = coins.sorted { $0.price > $1.price }
    }
    
  override func filterByBest24HourPerformance() {
        filteredCoins = coins.sorted { (Double($0.change.replacingOccurrences(of: "%", with: "")) ?? 0) > (Double($1.change.replacingOccurrences(of: "%", with: "")) ?? 0)
        }
    }
}
