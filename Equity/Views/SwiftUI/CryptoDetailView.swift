//
//  CryptoDetailView.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import SwiftUI

struct CryptoDetailView: View {
    let crypto: CryptoItem?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Section 1: Name & Price
                VStack(alignment: .leading, spacing: 10) {
                  Text(crypto?.name ?? "0")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                  Text("$\(crypto?.price ?? 0, specifier: "%.2f")")
                        .font(.title)
                        .foregroundColor(.green)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                // Section 2: Performance Graph
                VStack {
                    Text("Performance Chart")
                        .font(.headline)
                    /*Chart {
                        ForEach(crypto.performanceData, id: \.date) { data in
                            LineMark(
                                x: .value("Date", data.date),
                                y: .value("Price", data.price)
                            )
                        }
                    }
                    .frame(height: 200)*/
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                // Section 3: Other Statistics
                VStack(alignment: .leading, spacing: 10) {
                    Text("Other Statistics")
                        .font(.headline)

                    HStack {
                        Text("Market Cap:")
                        Spacer()
                      Text("$\(crypto?.marketCap ?? 0, specifier: "%.2f")")
                    }

                    HStack {
                        Text("Volume (24h):")
                        Spacer()
                      Text("$\(crypto?.volume24h ?? 0, specifier: "%.2f")")
                    }

                    HStack {
                        Text("Supply:")
                        Spacer()
                        Text("\(crypto?.supply ?? 0, specifier: "%.2f") coins")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
        .navigationTitle(crypto?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
              presentationMode.wrappedValue.dismiss()
            }) {
              HStack {
                Image(systemName: "arrow.left")
              }
              .foregroundColor(UIColor.toSwiftUIColor(for: .text))
            }
          }
        }
    }
}

// MARK: - Preview
//struct CryptoDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleData = [
//            CryptoPerformanceData(date: Date().addingTimeInterval(-86400 * 3), price: 50000),
//            CryptoPerformanceData(date: Date().addingTimeInterval(-86400 * 2), price: 51000),
//            CryptoPerformanceData(date: Date().addingTimeInterval(-86400 * 1), price: 52000),
//            CryptoPerformanceData(date: Date(), price: 53000)
//        ]
//
//        CryptoDetailView(crypto: CryptoItem(
//          from: <#Coin#>, name: "Bitcoin",
//            price: 53000,
//            marketCap: 1_000_000_000,
//            volume24h: 50_000_000,
//            symbol: "",
//            supply: 21_000_000,
//            iconUrl: "https://cdn.coinranking.com/iImvX5-OG/5426.png",
//            performanceData: sampleData
//        ))
//    }
//}
//
