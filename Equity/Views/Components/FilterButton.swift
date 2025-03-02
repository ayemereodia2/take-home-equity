//
//  FilterButton.swift
//  Equity
//
//  Created by ANDELA on 02/03/2025.
//

import SwiftUI

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void


    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(8)
                .background(isSelected ? Color.blue : UIColor.toSwiftUIColor(for: .background))
                .foregroundColor(isSelected ? .white : UIColor.toSwiftUIColor(for: .text))
                .animation(.easeInOut(duration: 0.2), value: isSelected)
                .cornerRadius(8)
                .fixedSize()

        }
    }
}

#Preview {
  FilterButton(title: "Absolute Change", isSelected: true, action: {})
}
