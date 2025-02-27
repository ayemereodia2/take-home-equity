//
//  CoinStats.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation

struct CoinStats: Decodable {
  let total: Int
  let totalCoins: Int
  let totalMarkets: Int
  let totalExchanges: Int
  let totalMarketCap: String
  let total24hVolume: String
}
