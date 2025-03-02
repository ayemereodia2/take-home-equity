//
//  MoneyFormat.swift
//  Equity
//
//  Created by ANDELA on 01/03/2025.
//

import Foundation

class MoneyFormat {
  
  static func formatPrice(
    _ price: Double,
    currencyCode: Currency
  ) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = currencyCode.rawValue
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter.string(from: NSNumber(value: price)) ?? "CA$ 0.00"
  }
}
