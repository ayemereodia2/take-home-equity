//
//  FavoritesCoinViewModel.swift
//  Equity
//
//  Created by ANDELA on 28/02/2025.
//

import Foundation

class FavoritesCoinViewModel: FavoritesCoinViewModelProtocol {

    @Published var favoriteCoins: [CryptoItem] = []
    @Published var errorMessage: String? = nil

    private let favoritesRepository: FavoritesRepository

    init(favoritesRepository: FavoritesRepository = UserDefaultsFavoritesRepository()) {
        self.favoritesRepository = favoritesRepository
        Task {
            await loadFavorites()
        }
    }

    /// Load favorite coins from repository
    func loadFavorites() async {
        do {
            let favorites = try favoritesRepository.getAllFavorites()
            await MainActor.run {
                self.favoriteCoins = favorites
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load favorites: \(error.localizedDescription)"
            }
        }
    }
    
    /// Reload favorites manually
    func reloadFavorites() async {
        await loadFavorites()
    }
  
    func toggleFavorite(crypto: CryptoItem?) async {
      guard let crypto else { return }
        do {
            let isFav = try favoritesRepository.isFavorite(cryptoId: crypto.id)
            if isFav {
                try favoritesRepository.removeFavorite(cryptoId: crypto.id)
            } else {
                try favoritesRepository.addFavorite(crypto: crypto)
            }
            await reloadFavorites() 
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to update favorite: \(error.localizedDescription)"
            }
        }
    }
  func removeFavorite(cryptoId: String) async {
    do {
      try favoritesRepository.removeFavorite(cryptoId: cryptoId)
      await reloadFavorites()
    } catch {
      await MainActor.run {
        self.errorMessage = "Failed to update favorite: \(error.localizedDescription)"
      }
    }
  }
}
