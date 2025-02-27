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
    @Published var isLoading = false
    @Published var hasMorePages = true
    
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    private let itemsPerPage = 20 // limit
    private var currentOffset = 0 // offset
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        fetchNextPage() // Initial fetch: offset=0, limit=20
    }
    
    func fetchNextPage() {
        guard !isLoading, hasMorePages else { return }
        isLoading = true
        
        networkService.fetchCoins(offset: currentOffset, limit: itemsPerPage)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching coins: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                let newCoins = response.data.coins.map { coin in
                  CryptoItem(name: "", price: 22, marketCap: 22, volume24h: 33, symbol: "", supply: 90, performanceData: [])
                }
                self.coins.append(contentsOf: newCoins)
                self.currentOffset += self.itemsPerPage // Move offset forward
                self.hasMorePages = self.currentOffset < 100 // Stop at 100 coins
            }
            .store(in: &cancellables)
    }
}
