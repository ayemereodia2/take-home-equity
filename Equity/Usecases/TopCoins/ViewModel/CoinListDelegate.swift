//
//  CoinListDelegate.swift
//  Equity
//
//  Created by ANDELA on 01/03/2025.
//

import UIKit

final class CoinListDelegate: NSObject, UITableViewDelegate {
    // MARK: - Properties
    private weak var viewController: CoinListViewController?
    
    // MARK: - Initializer
    init(viewController: CoinListViewController) {
        self.viewController = viewController
        super.init()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = viewController else { return }
        let selectedCrypto = viewController.viewModel.filteredCoins[indexPath.row]
      
      viewController.coordinator.showCryptoDetail(
        for: selectedCrypto,
        favoriteCoinViewModel: viewController.favoriteCoinViewModel
      )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let viewController = viewController else { return nil }
        let coinItem = viewController.viewModel.filteredCoins[indexPath.row]
        let cryptoId = coinItem.id
        let coinName = coinItem.symbol
        let isFavorite = viewController.viewModel.isFavorite(cryptoId: cryptoId)
        
        let favoriteAction = UIContextualAction(style: .normal, title: isFavorite ? "Unfavorite" : "Favorite") { [weak viewController] (_, _, completion) in
            guard let viewController = viewController else {
                completion(false)
                return
            }
            
            Task {
                await viewController.viewModel.toggleFavorite(cryptoId: cryptoId, coin: coinItem)
                DispatchQueue.main.async {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                let message = viewController.viewModel.isFavorite(cryptoId: cryptoId) ?
                NSLocalizedString("added_to_favorites", comment: "") :
                NSLocalizedString("removed_from_favorites", comment: "")
              PopupManager.showPopup(on: viewController, message: "\(coinName) \(message)", messageType: .info)
                completion(true)
            }
        }
        
        favoriteAction.image = UIImage(systemName: isFavorite ? "star.fill" : "star")
        favoriteAction.backgroundColor = isFavorite ? .systemYellow : .systemGray
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewController = viewController else { return }
        let threshold = 5
        if indexPath.row == viewController.viewModel.filteredCoins.count - threshold {
            viewController.viewModel.fetchNextPage()
        }
    }
}
