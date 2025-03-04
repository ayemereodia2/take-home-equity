//
//  CoinListDataSource.swift
//  Equity
//
//  Created by ANDELA on 01/03/2025.
//

import UIKit
import Combine

final class CoinListDataSource: NSObject, CoinListDataSourceProtocol {
    // MARK: - Properties
    private var viewModel: any CoinListViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
  init(viewModel: any CoinListViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinViewCell.identifier, for: indexPath) as? CoinViewCell else {
            return UITableViewCell()
        }
      
      guard indexPath.row < viewModel.filteredCoins.count else {
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        return UITableViewCell()
      }
        let coin = viewModel.filteredCoins[indexPath.row]
      tableView.separatorStyle = .singleLine
      tableView.allowsSelection = true
        cell.configureCell(model: coin)
        return cell
    }
   
}

protocol CoinListDataSourceProtocol: UITableViewDataSource {
    init(viewModel: any CoinListViewModelProtocol) // Required initializer
}
