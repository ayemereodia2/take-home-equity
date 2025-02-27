//
//  CryptoItem.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation

// MARK: - Sample Model
import Foundation

struct CryptoItem: Identifiable {
    let id: String
    let name: String
    let price: Double
    let marketCap: Double
    let volume24h: Double
    let symbol: String
    let supply: Double
    let iconUrl: String?
    
    init(from coin: Coin) {
        self.id = coin.id
        self.name = coin.name
        self.price = Double(coin.price) ?? 0.0
        self.marketCap = Double(coin.marketCap) ?? 0.0
        self.volume24h = Double(coin.volume24h) ?? 0.0
        self.symbol = coin.symbol
        self.supply = 0.0
        self.iconUrl = coin.iconUrl
    }
}


// MARK: - Sample Data Model for Chart
struct CryptoPerformanceData {
    let date: Date
    let price: Double
}
