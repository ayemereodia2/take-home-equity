//
//  UIViewController.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation
import UIKit

class NavigationBarCustomizer {
    static let shared = NavigationBarCustomizer()
    
    private init() {}
  
  func configureBackButton(for viewController: UIViewController) {
    let customBackImage = UIImage(systemName: "arrow.left")
    let customBackButton = UIBarButtonItem(image: customBackImage, style: .plain, target: nil, action: nil)
    customBackButton.tintColor = UIColor.dynamicColor(for: .text)
    customBackButton.accessibilityLabel = "Back"
    viewController.navigationItem.backBarButtonItem = customBackButton
  }
}
