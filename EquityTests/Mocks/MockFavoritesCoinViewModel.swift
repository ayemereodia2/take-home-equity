//
//  MockFavoritesCoinViewModel.swift
//  EquityTests
//
//  Created by ANDELA on 01/03/2025.
//

import Foundation
@testable import Equity
import Combine
import SwiftUI

final class MockFavoritesCoinViewModel: FavoritesCoinViewModel {
  var stubbedFavorites: [CryptoItem] = []
  var stubbedIsFavorite: Bool = false
  var shouldThrowError = false
  
  private(set) var addFavoriteCalled = false
  private(set) var removeFavoriteCalled = false
  // MARK: - Methods
  override func loadFavorites() async {
    favoriteCoins = [CryptoItem.mock()]
  }
  
  override func reloadFavorites() async {
    favoriteCoins = [CryptoItem.mock()]
  }
  
  override func toggleFavorite(crypto: CryptoItem?) async {
    guard let crypto else { return }
    if favoriteCoins.contains(where: { $0.id == crypto.id }) {
      favoriteCoins.removeAll { $0.id == crypto.id }
    } else {
      favoriteCoins.append(crypto)
    }
  }
  
  override func removeFavorite(cryptoId: String) async {
    favoriteCoins.removeAll { $0.id == cryptoId }
  }
}
