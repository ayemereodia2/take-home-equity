//
//  FavoritesCoinsView.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import SwiftUI

struct FavoritesCoinsView: View {
    @StateObject var viewModel = FavoritesCoinViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.favoriteCoins) { coin in
              NavigationLink(
                destination: CryptoDetailView(
                  crypto: coin,
                  viewModel: viewModel
                )
              ) {
                    CoinViewSUCell(coin: coin)
                }
            }
            .navigationTitle("Favorite Coins")
            .listStyle(.plain)
            .task {
                await viewModel.reloadFavorites() // Reload favorites when the view appears
            }
        }
    }
}


#Preview {
    FavoritesCoinsView()
}
