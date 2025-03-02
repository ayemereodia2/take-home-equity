//
//  CryptoDetailView.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import SwiftUI
import Charts
import DGCharts
import Combine

struct CryptoDetailView: View {
    let crypto: CryptoItem?
    var viewModel: any FavoritesCoinViewModelProtocol
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedFilter: PriceFilter = .raw
    @State private var selectedPrice: String?

    var isFavorite: Bool {
        viewModel.favoriteCoins.contains { $0.id == crypto?.id }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CryptoHeaderView(crypto: crypto, isFavorite: isFavorite, viewModel: viewModel)

                if let sparkline = crypto?.sparkLine {
                    PerformanceChartView(
                        sparkline: sparkline,
                        selectedFilter: $selectedFilter,
                        selectedPrice: $selectedPrice
                    )
                }

                StatisticsView(crypto: crypto)
            }
            .padding(.horizontal)
        }
        .navigationTitle(crypto?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(UIColor.toSwiftUIColor(for: .text))
                }
            }
        }
    }
}

enum PriceFilter {
    case absoluteChange
    case percentageChange
    case highestPrice
    case lowestPrice
    case raw
}

