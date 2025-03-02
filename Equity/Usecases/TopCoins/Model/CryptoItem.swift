//
//  CryptoItem.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation

// MARK: - Sample Model
import Foundation

struct CryptoItem: Identifiable,Codable {
    let id: String
    let name: String
    let price: Double
    let marketCap: Double
    let volume24h: Double
    let symbol: String
    let supply: Double
    let iconUrl: String?
    let change:String
    let sparkLine:[String?]?
    
    init(from coin: Coin) {
        self.id = coin.id
        self.name = coin.name
        self.price = Double(coin.price) ?? 0.0
        self.marketCap = Double(coin.marketCap) ?? 0.0
        self.volume24h = Double(coin.volume24h) ?? 0.0
        self.symbol = coin.symbol
        self.supply = 0.0
        self.iconUrl = coin.iconUrl
        self.change = coin.change
        self.sparkLine = coin.sparkline
    }
  
  // Memberwise initializer
      init(
          id: String,
          name: String,
          price: Double,
          marketCap: Double,
          volume24h: Double,
          symbol: String,
          supply: Double,
          iconUrl: String?,
          change: String,
          sparkLine: [String?]?
      ) {
          self.id = id
          self.name = name
          self.price = price
          self.marketCap = marketCap
          self.volume24h = volume24h
          self.symbol = symbol
          self.supply = supply
          self.iconUrl = iconUrl
          self.change = change
          self.sparkLine = sparkLine
      }
}

extension CryptoItem {
    /// A mock instance of `CryptoItem` for testing purposes.
    static func mock() -> CryptoItem {
        return CryptoItem(
            id: "bitcoin",
            name: "Bitcoin",
            price: 50000.0,
            marketCap: 1_000_000_000_000.0,
            volume24h: 50_000_000_000.0,
            symbol: "BTC",
            supply: 21_000_000.0,
            iconUrl: "https://example.com/bitcoin.png",
            change: "+5.0%",
            sparkLine: ["50000", "51000", "52000", "53000", "54000", "55000"]
        )
    }
  
  static func mockList() -> [CryptoItem] {
      return [
        CryptoItem(
          id: "bitcoin",
          name: "Bitcoin",
          price: 50000.0,
          marketCap: 1_000_000_000_000.0,
          volume24h: 50_000_000_000.0,
          symbol: "BTC",
          supply: 21_000_000.0,
          iconUrl: "https://example.com/bitcoin.png",
          change: "+5.0%",
          sparkLine: ["50000", "51000", "52000", "53000", "54000", "55000"]
      ),
        CryptoItem(
          id: "dogecoin",
          name: "Dogecoin",
          price: 20000.0,
          marketCap: 1_000_000_000_000.0,
          volume24h: 50_000_000_000.0,
          symbol: "DGC",
          supply: 21_000_000.0,
          iconUrl: "https://example.com/dogecoin.png",
          change: "+5.0%",
          sparkLine: ["50000", "51000", "52000", "53000", "54000", "55000"]
      )
      ]
  }
}
