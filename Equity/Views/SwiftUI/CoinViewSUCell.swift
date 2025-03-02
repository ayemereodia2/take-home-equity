//
//  CoinViewSUCell.swift
//  Equity
//
//  Created by ANDELA on 28/02/2025.
//

import SwiftUI

struct CoinViewSUCell: View {
  let coin: CryptoItem
  @State private var image: UIImage? = nil
  
  var body: some View {
    HStack(spacing: 15) {
      ZStack {
        Circle()
          .fill(Color.gray.opacity(0.3))
          .frame(width: 40, height: 40)
        
        if let uiImage = image {
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
        }
      }
      
      HStack(alignment: .center) {
        VStack(alignment: .leading, spacing: 4) {
          Text(coin.name)
            .font(.headline)
            .foregroundColor(UIColor.toSwiftUIColor(for: .text))
          Text(coin.symbol)
            .font(.subheadline)
            .foregroundColor(.gray)
        }
        
        Spacer()
        
        VStack(alignment: .trailing, spacing: 4) {
          Text(MoneyFormat.formatPrice(coin.price, currencyCode: .cad))
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(UIColor.toSwiftUIColor(for: .text))
          Text(String(format: "%.2f%%", Double(coin.change) ?? 0))
            .font(.subheadline)
            .padding(6)
            .background(Double(coin.change) ?? 0 >= 0 ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
            .cornerRadius(6)
            .foregroundColor(Double(coin.change) ?? 0 >= 0 ? .green : .red)
        }
      }
    }
    .task {
      await loadImage()
    }
  }
  
  private func loadImage() async {
    guard let url = coin.iconUrl else { return }
    image = await ImageLoaderUtil.loadFrom(iconUrl: url)
  }
}

