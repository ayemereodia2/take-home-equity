//
//  CryptoHeaderView.swift
//  Equity
//
//  Created by ANDELA on 02/03/2025.
//

import SwiftUI

struct CryptoHeaderView: View {
    let crypto: CryptoItem?
    let isFavorite: Bool
    var viewModel: any FavoritesCoinViewModelProtocol

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(crypto?.name ?? "N/A")
                    .font(.largeTitle.bold())
                Spacer()
                Button {
                    Task {
                        await viewModel.toggleFavorite(crypto: crypto)
                    }
                } label: {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .gray)
                        .frame(width: 40, height: 40)
                }
            }

            Text(MoneyFormat.formatPrice(crypto?.price ?? 0, currencyCode: .cad))
                .font(.title)
                .foregroundColor(.green)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
