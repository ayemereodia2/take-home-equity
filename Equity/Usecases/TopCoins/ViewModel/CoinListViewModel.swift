//
//  CoinListViewModel.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation
import Combine

class CoinListViewModel: CoinListViewModelProtocol {
  @Published var coins: [CryptoItem] = []
  @Published var filteredCoins: [CryptoItem] = []
  @Published var isLoading = false
  @Published var hasMorePages = true
  @Published var searchText: String = ""
  @Published var showNoResults = false
  @Published var errorMessage: String? = nil
  @Published var favoriteCoins: [CryptoItem] = []

  
  private let networkService: NetworkService
  private var cancellables = Set<AnyCancellable>()
  private let itemsPerPage = 20
  private var currentOffset = 0
  private let favoritesRepository: FavoritesRepository
  
  init(
    networkService: NetworkService,
    favoritesRepository: FavoritesRepository = UserDefaultsFavoritesRepository()
  ) {
    self.networkService = networkService
    self.favoritesRepository = favoritesRepository
    
    Task {
      await loadFavorites()
    }
    fetchNextPage()
    
    // Bind searchText to filter coins
    $searchText
      .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
      .sink { [weak self] newText in
        self?.filterCoins(searchText: newText)
      }
      .store(in: &cancellables)
    
    $filteredCoins
      .combineLatest($searchText)
      .map { filteredCoins, searchText in
        filteredCoins.isEmpty && !searchText.isEmpty
      }
      .assign(to: &$showNoResults)
  }
  
  func fetchNextPage() {
    guard !isLoading, hasMorePages else { return }
    isLoading = true
    
    networkService.fetchCoins(offset: currentOffset, limit: itemsPerPage)
      .sink { [weak self] completion in
        self?.isLoading = false
        if case .failure(let error) = completion {
          let errorMessage =
          NSLocalizedString("failed_to_load_data", comment: "")
          
          self?.errorMessage = "\(errorMessage): \(error.localizedDescription)"
          debugPrint("Error fetching coins: \(error)")
        }
      } receiveValue: { [weak self] response in
        guard let self = self else { return }
        let newCoins = response.data.coins.map { CryptoItem(from: $0) }
        self.coins.append(contentsOf: newCoins)
        self.filteredCoins = self.coins // Initial sync
        self.currentOffset += self.itemsPerPage
        self.hasMorePages = self.currentOffset < 100
      }
      .store(in: &cancellables)
  }
  
  private func filterCoins(searchText: String) {
    if searchText.isEmpty {
      filteredCoins = coins
    } else {
      filteredCoins = coins.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
  }
  
  func resetSearch() {
    searchText = ""
    retryFetch()
  }
  func retryFetch() {
    currentOffset = 0
    coins.removeAll()
    filteredCoins.removeAll()
    fetchNextPage()
  }
  
  private func loadFavorites() async {
    do {
      let favorites = try favoritesRepository.getAllFavorites()
      await MainActor.run { favoriteCoins = favorites }
    } catch {
      let errorLocalMsg = NSLocalizedString("failed_to_load_favorites", comment: "")
      await MainActor.run { errorMessage = "\(errorLocalMsg): \(error.localizedDescription)" }
    }
  }
  
  func toggleFavorite(cryptoId: String, coin: CryptoItem) async {
    do {
      let isFavorite = try favoritesRepository.isFavorite(cryptoId: cryptoId)
      if isFavorite {
        try favoritesRepository.removeFavorite(cryptoId: cryptoId)
      } else {
        try favoritesRepository.addFavorite(crypto: coin)
      }
      
      // Reload favorites to reflect the latest state
      let updatedFavorites = try favoritesRepository.getAllFavorites()
      await MainActor.run {
        favoriteCoins = updatedFavorites
        objectWillChange.send() // Ensures SwiftUI updates any views depending on this data
      }
    } catch {
      let errorLocalUpdateMsg = NSLocalizedString("failed_to_update_favorites", comment: "")
      await MainActor.run { errorMessage = "\(errorLocalUpdateMsg): \(error.localizedDescription)" }
    }
  }
  
  
  func isFavorite(cryptoId: String) -> Bool {
    favoriteCoins.contains(where: {$0.id == cryptoId })
  }
  
  func filterByHighestPrice() {
    filteredCoins = coins.sorted { $0.price > $1.price }
  }
  
  func filterByBest24HourPerformance() {
    filteredCoins = coins.sorted { (Double($0.change.replacingOccurrences(of: "%", with: "")) ?? 0) > (Double($1.change.replacingOccurrences(of: "%", with: "")) ?? 0)
    }
  }
  
  func applyFilter(_ filterType: FilterType) {
      switch filterType {
      case .highestPrice:
          filterByHighestPrice()
      case .best24Hour:
          filterByBest24HourPerformance()
      }
  }

}

enum FilterType {
  case highestPrice
  case best24Hour
}
