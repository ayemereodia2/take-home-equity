//
//  MainTabBarControllerViewController.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
    private let coinListCoordinator: CoinListCoordinator
    
    // Accept Navigation Controller from SceneDelegate
    init(navigationController: UINavigationController) {
        self.coinListCoordinator = CoinListCoordinator(navigationController: navigationController)
        super.init(nibName: nil, bundle: nil)
        
        setupTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTabBar() {
        // Start the CoinListCoordinator
        coinListCoordinator.start()
        
        let coinListVC = coinListCoordinator.navigationController
        coinListVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)

        let favoritesVC = UIHostingController(rootView: FavoritesCoinsView())
        favoritesVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "star"), tag: 1)

        let chartsVC = UINavigationController(rootViewController: PlaceholderViewController(title: ""))
        chartsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "chart.bar"), tag: 2)

        let settingsVC = UINavigationController(rootViewController: PlaceholderViewController(title: ""))
        settingsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "gear"), tag: 3)

        // Set View Controllers
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

