//
//  HeaderViewModel.swift
//  Equity
//
//  Created by ANDELA on 02/03/2025.
//

import Foundation
import SwiftUI

class HeaderViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var filterOptions: [FilterOption] = [
        FilterOption(
          id: "filter",
          title: "",
          imageTitle: "slider.horizontal.2.square"),
        FilterOption(
          id: "allAssets",
          title: "All assets",
          imageTitle: nil),
        FilterOption(
          id: "marketCap",
          title: "Market cap",
          imageTitle: nil)
    ]
  
    @Published var selectedFilterId: String?
    @Published var isSearchActive: Bool = false
    
    
    func selectFilter(at index: Int) {
        guard index < filterOptions.count else { return }
        let option = filterOptions[index]
        selectedFilterId = (selectedFilterId == option.id) ? nil : option.id
    }
    
    func toggleSearch() {
        isSearchActive.toggle()
    }
    
    func filterOption(at index: Int) -> FilterOption? {
        guard index < filterOptions.count else { return nil }
        return filterOptions[index]
    }
    
    func isSelected(_ option: FilterOption) -> Bool {
        selectedFilterId == option.id
    }
}
