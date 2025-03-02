//
//  StatisticsView.swift
//  Equity
//
//  Created by ANDELA on 02/03/2025.
//

import SwiftUI

struct StatisticsView: View {
    let crypto: CryptoItem?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Other Statistics")
                .font(.title3.bold())

          StatisticRow(label: NSLocalizedString("market_cap", comment: ""), value:MoneyFormat.formatPrice(crypto?.marketCap ?? 0, currencyCode: .cad))
          StatisticRow(label: NSLocalizedString("volume_24h", comment: ""), value: MoneyFormat.formatPrice(crypto?.volume24h ?? 0, currencyCode: .cad))
          StatisticRow(label: NSLocalizedString("supply", comment: ""), value: MoneyFormat.formatPrice(crypto?.supply ?? 0, currencyCode: .cad))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    //StatisticsView()
}
