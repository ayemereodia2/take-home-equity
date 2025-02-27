//
//  CryptoItem.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation

// MARK: - Sample Model
struct CryptoItem {
    let name: String
    let price: Double
    let marketCap: Double
    let volume24h: Double
    let symbol: String
    let supply: Double
    let iconUrl: String
    let performanceData: [CryptoPerformanceData]
}

// MARK: - Sample Data Model for Chart
struct CryptoPerformanceData {
    let date: Date
    let price: Double
}
