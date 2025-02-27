//
//  ColorUtility.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation
import UIKit
import SwiftUICore

// Enum to manage app-wide color schemes
enum AppColorScheme {
    case border
    case background
    case text
    // Add more cases as needed
    
    var lightModeColor: UIColor {
        switch self {
        case .border:
            return .systemGray
        case .background:
            return .white
        case .text:
            return .black
        }
    }
    
    var darkModeColor: UIColor {
        switch self {
        case .border:
            return .lightGray
        case .background:
            return .black
        case .text:
            return .white
        }
    }
}

// Extension to UIColor for dynamic color support
extension UIColor {
    static func dynamicColor(for scheme: AppColorScheme) -> UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return scheme.darkModeColor
            default:
                return scheme.lightModeColor
            }
        }
    }
    
    // Convenience method to get CGColor directly
    static func dynamicCGColor(for scheme: AppColorScheme) -> CGColor {
        return dynamicColor(for: scheme).cgColor
    }
  
  static func toSwiftUIColor(for scheme: AppColorScheme) -> Color {
    return Color(dynamicColor(for: scheme))
  }
}
