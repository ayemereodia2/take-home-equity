//
//  CoinListCoordinator.swift
//  Equity
//
//  Created by ANDELA on 01/03/2025.
//

import UIKit
import SwiftUI

class CoinListCoordinator {
  let navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let viewModel = CoinListViewModel(networkService: APIService())
    let favoriteViewModel = FavoritesCoinViewModel()
    
    let coinListVC = CoinListViewController(
      viewModel: viewModel,
      favoriteCoinViewModel: favoriteViewModel,
      coordinator: self
    )
    
    navigationController.viewControllers = [coinListVC] // Set as Root VC
  }
  
  func showCryptoDetail(
    for crypto: CryptoItem,
    favoriteCoinViewModel: FavoritesCoinViewModel
  ) {
    let detailView = CryptoDetailView(crypto: crypto, viewModel: favoriteCoinViewModel)
    let hostingController = UIHostingController(rootView: detailView)
    hostingController.navigationItem.hidesBackButton = true
    hostingController.navigationItem.backBarButtonItem = nil
  
    navigationController.pushViewController(hostingController, animated: true)
  }
  
  func presentFilterSheet(
    from viewController: CoinListViewController,
    viewModel: CoinListViewModel
  ) {
    
    let filterVC = FilterViewController(
      highestPriceAction: { [weak viewModel] in
        viewModel?.filterByHighestPrice()
        
      },
      best24HourAction: { [weak viewModel] in
        viewModel?.filterByBest24HourPerformance()
      }
    )
    
    if let sheet = filterVC.sheetPresentationController {
      sheet.detents = [.medium()]
      sheet.prefersGrabberVisible = true
      sheet.preferredCornerRadius = 20
      sheet.selectedDetentIdentifier = .large
    }
    viewController.present(filterVC, animated: true, completion: nil)
  }
}

