//
//  PopupManager.swift
//  Equity
//
//  Created by ANDELA on 01/03/2025.
//

import UIKit
import SwiftUI

class PopupManager {
    static func showPopup(on viewController: UIViewController, message: String, messageType: MessageType) {
        let popupView = PopupView(message: message, isVisible: .constant(true), messageType: messageType)
        let hostingController = UIHostingController(rootView: popupView)
        
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        viewController.addChild(hostingController)
        viewController.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: viewController)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            hostingController.view.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            hostingController.willMove(toParent: nil)
            hostingController.view.removeFromSuperview()
            hostingController.removeFromParent()
        }
    }
}
