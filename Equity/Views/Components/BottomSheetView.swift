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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(filterLabel)
        NSLayoutConstraint.activate([
            filterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            filterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            filterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            filterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        filterLabel.text = text
    }
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let filterOptions = [
        "Highest Price",
        "Best 24-Hour Performance",
        "Filter Option 3",
        "Filter Option 4"
    ]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        return filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as! FilterTableViewCell
        let filterText = filterOptions[indexPath.row]
        cell.configure(with: filterText)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilter = filterOptions[indexPath.row]
        print("Selected filter: \(selectedFilter)")
        switch selectedFilter {
        case "Highest Price":
            filterByHighestPrice()
        case "Best 24-Hour Performance":
            filterByBestPerformance()
        default:
            break
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func filterByHighestPrice() {
        print("Filtered by Highest Price")
    }
    
    private func filterByBestPerformance() {
        print("Filtered by Best 24-Hour Performance")
    }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    80
  }
}
