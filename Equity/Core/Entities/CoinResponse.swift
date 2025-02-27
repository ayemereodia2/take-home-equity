//
//  CoinResponse.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation

struct CoinResponse: Decodable {
    let status: String
    let data: CoinData
}
