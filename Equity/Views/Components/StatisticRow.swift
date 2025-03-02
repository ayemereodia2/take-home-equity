//
//  StatisticRow.swift
//  Equity
//
//  Created by ANDELA on 02/03/2025.
//

import SwiftUI

struct StatisticRow: View {
    let label: String
    let value: String

    var body: some View {
      HStack(alignment: .firstTextBaseline) {
        Text(label)
          .font(.headline)
          .foregroundColor(.secondary)
        Spacer()
        Text(value)
          .font(.caption)
          .fontWeight(.bold)
          .foregroundColor(.primary)
        }
        .padding(.vertical, 0)
    }
}

#Preview {
  StatisticRow(label: "Stat", value: "Row")
}
