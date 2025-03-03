//
//  SceneDelegate.swift
//  Equity
//
//  Created by ANDELA on 25/02/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    // Create Navigation Controller
    let navigationController = UINavigationController()
    window.rootViewController = MainTabBarController(
      navigationController: navigationController
    )
    window.makeKeyAndVisible()
    self.window = window
  }


}

