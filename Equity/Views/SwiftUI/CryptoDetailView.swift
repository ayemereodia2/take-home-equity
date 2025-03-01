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
    var isFavorite: Bool {
        viewModel.favoriteCoins.contains { $0.id == crypto?.id }
    }
    @ObservedObject var viewModel: FavoritesCoinViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                  HStack {
                    Text(crypto?.name ?? "0")
                          .font(.largeTitle)
                          .fontWeight(.bold)
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
                  if let sparkline = crypto?.sparkLine {
                    LineChart(sparkline: sparkline)
                      .frame(height: 200)
                  } else {
                    Text("No chart data available")
                      .frame(height: 200)
                      .foregroundColor(.gray)
                  }
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

struct LineChart: UIViewControllerRepresentable {
    let sparkline: [String?] // Input data
    
    func makeUIViewController(context: Context) -> UIViewController {
        let chartViewController = UIViewController()
        let lineChartView = LineChartView(frame: .zero)
        
        // Configure chart appearance
        lineChartView.chartDescription.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.labelFont = .systemFont(ofSize: 12)
        lineChartView.xAxis.labelFont = .systemFont(ofSize: 12)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.pinchZoomEnabled = true
        lineChartView.doubleTapToZoomEnabled = false
        
        // Add chart to view controller
        chartViewController.view = lineChartView
        chartViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Set chart data
        setChartData(for: lineChartView)
        
        return chartViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update chart if needed (e.g., if sparkline changes)
        if let lineChartView = uiViewController.view as? LineChartView {
            setChartData(for: lineChartView)
        }
    }
    
    private func setChartData(for chartView: LineChartView) {
        // Convert sparkline data to ChartDataEntry
        var entries: [ChartDataEntry] = []
        for (index, value) in sparkline.enumerated() {
            if let priceString = value, let price = Double(priceString) {
                entries.append(ChartDataEntry(x: Double(index), y: price))
            }
        }
        
        // Create data set
        let dataSet = LineChartDataSet(entries: entries, label: "Price")
        dataSet.drawCirclesEnabled = false // No dots on the line
        dataSet.lineWidth = 2.0
        dataSet.setColor(.systemBlue) // Line color
        dataSet.drawFilledEnabled = true // Fill under the line
        dataSet.fillColor = .systemBlue.withAlphaComponent(0.2)
        dataSet.drawValuesEnabled = false // Hide data point values
        
        // Set data to chart
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
    }
}
