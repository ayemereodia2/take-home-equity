//
//  FilterViewModel.swift
//  Equity
//
//  Created by ANDELA on 02/03/2025.
//

import Foundation
import SwiftUI

class FilterViewModel: ObservableObject {
  // MARK: - Properties
  @Published var filterOptions: [FilterOption]
  @Published var selectedFilter: FilterOption? {
    didSet {
      saveSelectedFilter()
    }
  }
  private let repository: GenericUserDefaultsRepository<FilterOption>
  
  // MARK: - Filter Option Model
  struct FilterOption: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    
    static func == (lhs: FilterOption, rhs: FilterOption) -> Bool {
      lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
      case id, title
    }
  }
  private let highestPriceAction: () -> Void
  private let best24HourAction: () -> Void
  
  // MARK: - Initialization
  init(
    highestPriceAction: @escaping () -> Void,
    best24HourAction: @escaping () -> Void
  ) {
    self.filterOptions = [
      FilterOption(id: "highestPrice", title: "Highest Price"),
      FilterOption(id: "best24Hour", title: "Best 24-Hour Performance")
    ]
    self.repository = GenericUserDefaultsRepository<FilterOption>(userDefaults: .standard, storageNamespace: "filters")
    
    self.highestPriceAction = highestPriceAction
    self.best24HourAction = best24HourAction
    self.selectedFilter = loadSelectedFilter()
    
  }
  
  func selectFilter(at index: Int) {
    guard index < filterOptions.count else { return }
    let selectedOption = filterOptions[index]
    if selectedFilter == selectedOption {
      selectedFilter = nil
    } else {
      selectedFilter = selectedOption
      switch selectedOption.title {
      case "Highest Price": highestPriceAction()
      case "Best 24-Hour Performance": best24HourAction()
      default: break
      }
    }
  }
  
  func isSelected(_ option: FilterOption) -> Bool {
    return selectedFilter == option
  }
  
  private func saveSelectedFilter() {
    if let filter = selectedFilter {
      do {
        try repository.add(filter)
      } catch {
        debugPrint("Failed to save filter: \(error)")
      }
    } else {
      filterOptions.forEach { try? repository.remove(id: $0.id) }
    }
  }
  
  private func loadSelectedFilter() -> FilterOption? {
    do {
      let savedFilters = try repository.getAll()
      if let savedFilter = savedFilters.first,
         let matchingOption = filterOptions.first(where: { $0.title == savedFilter.title }) {
        return matchingOption
      }
      return nil
    } catch {
      debugPrint("Failed to load filter: \(error)")
      return nil
    }
  }
}
