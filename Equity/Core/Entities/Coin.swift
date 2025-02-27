//
//  Coin.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation
struct Coin: Decodable, Identifiable {
    let symbol: String
    let color: String?
    let name: String
    let iconUrl: String?
    let marketCap: String
    let id: String
    let price: String
    let listedAt: Int?
    let tier: Int?
    let change: String
    let rank: Int
    let sparkline: [String?]?
    let lowVolume: Bool?
    let coinrankingUrl: String
    let volume24h: String
    let btcPrice: String?
    let contractAddresses: [String]?
  
  
  enum CodingKeys: String, CodingKey {
          case id = "uuid"
          case symbol
          case name
          case color
          case iconUrl
          case marketCap
          case price
          case listedAt
          case tier
          case change
          case rank
          case sparkline
          case lowVolume
          case coinrankingUrl
          case volume24h = "24hVolume"
          case btcPrice
          case contractAddresses
      }
}

