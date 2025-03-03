//
//  FilterViewController.swift
//  Equity
//
//  Created by ANDELA on 02/03/2025.
//

import UIKit

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
    tableView.register(BottomSheetFilterView.self, forCellReuseIdentifier: BottomSheetFilterView.identifier)
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
    let cell = tableView.dequeueReusableCell(withIdentifier: BottomSheetFilterView.identifier, for: indexPath) as! BottomSheetFilterView
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
    highestPriceAction?()
  }
  
  private func filterByBestPerformance() {
    best24HourAction?()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    80
  }
}
