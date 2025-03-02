//
//  BottomSheetView.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    static let identifier = "FilterTableViewCell"
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let checkbox: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(filterLabel)
        contentView.addSubview(checkbox)
        
        NSLayoutConstraint.activate([
            filterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            filterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            filterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkbox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            checkbox.widthAnchor.constraint(equalToConstant: 24),
            checkbox.heightAnchor.constraint(equalToConstant: 24),
            filterLabel.trailingAnchor.constraint(equalTo: checkbox.leadingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String, isSelected: Bool) {
        filterLabel.text = text
        checkbox.image = UIImage(systemName: isSelected ? "checkmark.square.fill" : "square")
    }
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var highestPriceAction: (() -> Void)?
    var best24HourAction: (() -> Void)?
    private let viewModel: FilterViewModel
  
  init(
    highestPriceAction: @escaping () -> Void,
    best24HourAction: @escaping () -> Void
  ) {
    self.viewModel = FilterViewModel(
      highestPriceAction: highestPriceAction,
      best24HourAction: best24HourAction
    )
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dynamicColor(for: .background)
        // Set up table view
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      viewModel.filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as! FilterTableViewCell
      let option = viewModel.filterOptions[indexPath.row]
      let isSelected = viewModel.isSelected(option)
      cell.configure(with: option.title, isSelected: isSelected)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      viewModel.selectFilter(at: indexPath.row)
      tableView.reloadData()
      dismiss(animated: true, completion: nil)
    }
    
    private func filterByHighestPrice() {
        // Filtered coins by Highest Price
      highestPriceAction?()
    }
    
    private func filterByBestPerformance() {
        // Filtered coins by Best 24-Hour Performance
      best24HourAction?()
    }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    80
  }
}


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
          FilterOption(id: UUID().uuidString, title: "Highest Price"),
          FilterOption(id: UUID().uuidString, title: "Best 24-Hour Performance")
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
      switch selectedOption.title {
      case "Highest Price": highestPriceAction()
      case "Best 24-Hour Performance": best24HourAction()
      default: break
      }
    }
  }
  
  func isSelected(_ option: FilterOption) -> Bool {
    selectedFilter == option
  }
  
  private func saveSelectedFilter() {
    if let filter = selectedFilter {
      do {
        try repository.add(filter)
      } catch {
        print("Failed to save filter: \(error)")
      }
    } else {
      // Remove all filters to deselect (simplified approach)
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
