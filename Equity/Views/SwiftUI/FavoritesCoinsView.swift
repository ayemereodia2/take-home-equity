//
//  FavoritesCoinsView.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import SwiftUI

struct FavoritesCoinsView: View {
  @StateObject var viewModel = FavoritesCoinViewModel()
  @State private var isPopupVisible = false
  @State private var popupMessage = ""
  @State private var popupMessageType: MessageType = .info
  
    var body: some View {
      NavigationStack {
        ZStack {
            List(viewModel.favoriteCoins) { coin in
              NavigationLink(
                destination: CryptoDetailView(
                  crypto: coin,
                  viewModel: viewModel
                )
              ) {
                    CoinViewSUCell(coin: coin)
                }
              .buttonStyle(PlainButtonStyle())
              .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                  Task {
                    await viewModel.removeFavorite(cryptoId: coin.id)
                    popupMessage = "\(coin.name) removed from favorites"
                    popupMessageType = .info
                    isPopupVisible = true
                  }
                } label: {
                  Label("", systemImage: "star.slash")
                }
                .tint(.red)
              }
            
            }
            .navigationTitle("Favorite Coins")
            .listStyle(.plain)
            .task {
                await viewModel.reloadFavorites() 
            }
          
          PopupView(
            message: popupMessage,
            isVisible: $isPopupVisible,
            messageType: popupMessageType
          )
        }
      }
    }
}


#Preview {
    FavoritesCoinsView()
}
