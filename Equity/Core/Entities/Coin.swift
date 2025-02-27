//
//  Coin.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation
struct Coin: Decodable {
    let symbol: String
    let color: String
    let name: String
    let iconUrl: String
    let marketCap: String
    let uuid: String
    let price: String
    let listedAt: Int64
    let tier: Int
    let change: String
    let rank: Int
    let sparkline: [String]
    let lowVolume: Bool
    let coinrankingUrl: String
    let volume24h: String
    let btcPrice: String
    let contractAddresses: [String]
}

