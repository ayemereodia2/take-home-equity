//
//  TestResponse.swift
//  EquityTests
//
//  Created by ANDELA on 01/03/2025.
//

import Foundation

@testable import Equity

extension CoinResponse {
    static func mock() -> CoinResponse {
        CoinResponse(
            status: "success",
            data: CoinData.mock()
        )
    }
}

extension CoinData {
    static func mock() -> CoinData {
        CoinData(
            coins: [Coin.mockBitcoin(), Coin.mockEthereum()],
            stats: CoinStats.mock()
        )
    }
}

extension Coin {
    static func mockBitcoin() -> Coin {
        Coin(
            symbol: "BTC",
            color: "#F7931A",
            name: "Bitcoin",
            iconUrl: "https://cdn.coinranking.com/btc-icon.png",
            marketCap: "1200000000000",
            id: "Qwsogvtv82FCd",
            price: "65000.123456",
            listedAt: 1234567890,
            tier: 1,
            change: "+2.34",
            rank: 1,
            sparkline: [
                "64000.50",
                "64500.75",
                "65000.12",
                "64800.33",
                nil // Simulating missing data
            ],
            lowVolume: false,
            coinrankingUrl: "https://coinranking.com/coin/Qwsogvtv82FCd",
            volume24h: "35000000000",
            btcPrice: "1",
            contractAddresses: nil
        )
    }
    
    static func mockEthereum() -> Coin {
        Coin(
            symbol: "ETH",
            color: "#627EEA",
            name: "Ethereum",
            iconUrl: "https://cdn.coinranking.com/eth-icon.png",
            marketCap: "400000000000",
            id: "razxDUgYGNAdQ",
            price: "3000.56789",
            listedAt: 1438916400,
            tier: 1,
            change: "-1.12",
            rank: 2,
            sparkline: [
                "2950.00",
                "2980.25",
                "3000.56",
                "2990.78",
                nil
            ],
            lowVolume: false,
            coinrankingUrl: "https://coinranking.com/coin/razxDUgYGNAdQ",
            volume24h: "15000000000",
            btcPrice: "0.0461538",
            contractAddresses: ["0x1234abcd"]
        )
    }
}

extension CoinStats {
    static func mock() -> CoinStats {
        CoinStats(
            total: 25000,
            totalCoins: 18000,
            totalMarkets: 45000,
            totalExchanges: 300,
            totalMarketCap: "2500000000000",
            total24hVolume: "100000000000"
        )
    }
}
