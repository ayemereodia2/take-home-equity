//
//  CoinListViewModel.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation
import Combine

class CoinListViewModel: ObservableObject {
    @Published var coins: [CryptoItem] = []
    @Published var filteredCoins: [CryptoItem] = []
    @Published var isLoading = false
    @Published var hasMorePages = true
    @Published var searchText: String = ""
    @Published var showNoResults = false
  
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    private let itemsPerPage = 20
    private var currentOffset = 0
    private var tempCoindata: [CryptoItem] = []

    
    init(networkService: NetworkService) {
        self.networkService = networkService
        fetchNextPage()
      
      $searchText
        .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
        .sink { [weak self] newText in
          self?.filterCoins(searchText: newText)
        }
        .store(in: &cancellables)
      
      $filteredCoins
        .map { $0.isEmpty && !self.searchText.isEmpty }
        .assign(to: &$showNoResults)
    }
    
    func fetchNextPage() {
        guard !isLoading, hasMorePages else { return }
        isLoading = true
        
        networkService.fetchCoins(offset: currentOffset, limit: itemsPerPage)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    debugPrint("Error fetching coins: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                let newCoins = response.data.coins.map { CryptoItem(from: $0) }
                self.tempCoindata.append(contentsOf: newCoins)
                self.coins = self.tempCoindata
                self.filteredCoins = self.coins
                self.currentOffset += self.itemsPerPage // Move offset forward
                self.hasMorePages = self.currentOffset < 100 // Stop at 100 coins
            }
            .store(in: &cancellables)
    }
  
  private func filterCoins(searchText: String) {
    if searchText.isEmpty {
      resetSearch()
    } else {
      filteredCoins = coins.filter { $0.name.lowercased().contains(searchText.lowercased()) }
      
    }
  }
  
  func resetSearch() {
    searchText = ""
    filteredCoins = coins 
    print("Reset search, coins count: \(coins.count)")
  }
}
