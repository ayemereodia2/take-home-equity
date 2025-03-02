//
//  PerformanceChartView.swift
//  Equity
//
//  Created by ANDELA on 02/03/2025.
//

import SwiftUI
struct PerformanceChartView: View {
    let sparkline: [String?]
    @Binding var selectedFilter: PriceFilter
    @Binding var selectedPrice: String?

    var body: some View {
        VStack {
            Text(NSLocalizedString("performance_chart", comment: ""))
                .font(.headline)

          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
              FilterButton(
                title: NSLocalizedString("absolute_change", comment: ""),
                isSelected: selectedFilter == .absoluteChange
              ) {
                selectedFilter = .absoluteChange
              }
              FilterButton(
                title: NSLocalizedString("perc_change", comment: ""),
                isSelected: selectedFilter == .percentageChange
              ) {
                selectedFilter = .percentageChange
              }
              FilterButton(
                title: NSLocalizedString("highest", comment: ""),
                isSelected: selectedFilter == .highestPrice
              ) {
                selectedFilter = .highestPrice
              }
              FilterButton(
                title: NSLocalizedString("lowest", comment: ""),
                isSelected: selectedFilter == .lowestPrice
              ) {
                selectedFilter = .lowestPrice
              }
            }
            .padding(.horizontal, 8) // Padding inside ScrollView
          }

            LineChart(sparkline: sparkline, selectedFilter: $selectedFilter, selectedPrice: $selectedPrice)
                .frame(height: 200)

            if let price = selectedPrice {
                Text("Point: \(price)")
                    .font(.headline)
                    .foregroundColor(UIColor.toSwiftUIColor(for: .text))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
