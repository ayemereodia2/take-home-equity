//
//  LineChart.swift
//  Equity
//
//  Created by ANDELA on 02/03/2025.
//

import SwiftUI
import DGCharts

struct LineChart: UIViewControllerRepresentable {
    let sparkline: [String?] // Input data
    @Binding var selectedFilter: PriceFilter
    @Binding var selectedPrice: String?
  
    func makeUIViewController(context: Context) -> UIViewController {
        let chartViewController = UIViewController()
        let lineChartView = LineChartView(frame: .zero)
        
        configureChartAppearance(lineChartView)
        chartViewController.view = lineChartView
        chartViewController.view.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.delegate = context.coordinator  // Set delegate

        setChartData(for: lineChartView)
        
        return chartViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let lineChartView = uiViewController.view as? LineChartView {
            setChartData(for: lineChartView)
        }
    }
    
    private func configureChartAppearance(_ chartView: LineChartView) {
        chartView.chartDescription.enabled = false
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.labelFont = .systemFont(ofSize: 12)
        chartView.xAxis.labelFont = .systemFont(ofSize: 12)
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = true
        chartView.pinchZoomEnabled = true
        chartView.doubleTapToZoomEnabled = false
        chartView.highlightPerTapEnabled = true
    }
    
    private func setChartData(for chartView: LineChartView) {
        var entries: [ChartDataEntry] = []
        let transformedData = processData(sparkline, using: selectedFilter)
        
        for (index, value) in transformedData.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: value))
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: "Price")
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 2.0
        dataSet.setColor(.systemBlue)
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = .systemBlue.withAlphaComponent(0.2)
        dataSet.drawValuesEnabled = false
        dataSet.setCircleColor(.systemRed)
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
    }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  private func processData(_ sparkline: [String?], using filter: PriceFilter) -> [Double] {
      let prices = sparkline.compactMap { $0.flatMap(Double.init) }
      guard !prices.isEmpty else { return [] }

      switch filter {
      case .absoluteChange:
          return zip(prices.dropFirst(), prices).map { $0 - $1 } // Pairwise differences
      case .percentageChange:
          return zip(prices.dropFirst(), prices).map { (($0 - $1) / $1) * 100 }
      case .highestPrice:
          return prices.map { _ in prices.max() ?? 0 }
      case .lowestPrice:
          return prices.map { _ in prices.min() ?? 0 }
      case .raw:
          return prices
      }
  }
  
  class Coordinator: NSObject, ChartViewDelegate {
    var parent: LineChart
    
    init(_ parent: LineChart) {
      self.parent = parent
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
      DispatchQueue.main.async {
        self.parent.selectedPrice = String(format: "%.2f", entry.y)
      }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
      DispatchQueue.main.async {
        self.parent.selectedPrice = nil
      }
    }
  }

}

#Preview {
    //LineChart()
}
