//
//  FavoritesCoinsView.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import SwiftUI

struct Coin1: Identifiable {
    let id = UUID()
    let name: String
    let shortName: String
    let price: String
    let performance: String
    let performanceColor: Color
    let iconName: String
}

struct CoinViewSUCell: View {
    let coin: Coin1
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                Image(systemName: coin.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(coin.name)
                    .font(.headline)
                    .foregroundColor(UIColor.toSwiftUIColor(for: .text))
                Text(coin.shortName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(coin.price)
                    .font(.headline)
                    .foregroundColor(.gray)
                Text(coin.performance)
                    .font(.subheadline)
                    .padding(6)
                    .background(coin.performanceColor.opacity(0.3))
                    .cornerRadius(6)
                    .foregroundColor(coin.performanceColor)
            }
        }
        
    }
}

struct FavoritesCoinsView: View {
    let favoriteCoins: [Coin1] = [
      Coin1(name: "Tether", shortName: "USDT", price: "CA$ 3.28", performance: "0.10%", performanceColor: .green, iconName: "brain.head.profile"),
      Coin1(name: "Bitcoin", shortName: "BTC", price: "CA$ 55,000", performance: "-0.45%", performanceColor: .red, iconName: "bitcoinsign.circle"),
      Coin1(name: "Ethereum", shortName: "ETH", price: "CA$ 3,200", performance: "+1.2%", performanceColor: .green, iconName: "e.circle")
    ]
    
    var body: some View {
        NavigationStack {
            List(favoriteCoins) { coin in
              NavigationLink(destination: CryptoDetailView(crypto: nil)) {
                CoinViewSUCell(coin: coin)
              }
            }
            .navigationTitle("Favorite Coins")
            .listStyle(.plain)
        }
    }
}

struct FavoritesCoinsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesCoinsView()
    }
}


#Preview {
    FavoritesCoinsView()
}
