//
//  CoinData.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation

struct CoinData: Decodable {
    let coins: [Coin]
    let stats: CoinStats
}
