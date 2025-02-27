//
//  MainTabBarControllerViewController.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let coinListVC = UINavigationController(rootViewController: CoinListViewController(viewModel: CoinListViewModel(networkService: APIService())))
    
    coinListVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)
    
    let favoritesVC = UIHostingController(rootView: FavoritesCoinsView())
    
    favoritesVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "star"), tag: 1)
    
    let chartsVC = UINavigationController(rootViewController: PlaceholderViewController(title: ""))
    chartsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "chart.bar"), tag: 2)
    
    let settingsVC = UINavigationController(rootViewController: PlaceholderViewController(title: ""))
    settingsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "gear"), tag: 3)
    
    viewControllers = [coinListVC, favoritesVC, chartsVC, settingsVC]
    configureTabBarAppearance()
  }
  
  
  private func configureTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithTransparentBackground()
    
    appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
    appearance.shadowImage = nil
    appearance.shadowColor = nil
    
    appearance.stackedLayoutAppearance.normal.iconColor = UIColor.label
    appearance.stackedLayoutAppearance.selected.iconColor = UIColor.label
    
    tabBar.standardAppearance = appearance
    if #available(iOS 15.0, *) {
      tabBar.scrollEdgeAppearance = appearance
    }
  }
}

class PlaceholderViewController: UIViewController {
  private let screenTitle: String
  
  init(title: String) {
    self.screenTitle = title
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = screenTitle
  }
}

class FilterViewModel {
    var filterType: String?
    
    init(filterType: String? = nil) {
        self.filterType = filterType
    }
    
    func updateFilter(type: String) {
        filterType = type
    }
}
