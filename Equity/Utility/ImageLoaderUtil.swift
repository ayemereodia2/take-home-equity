//
//  ImageLoaderUtil.swift
//  Equity
//
//  Created by ANDELA on 28/02/2025.
//

import Foundation
import UIKit

class ImageLoaderUtil {
    static func loadFrom(iconUrl: String) async -> UIImage? {
        guard let url = URL(string: iconUrl) else {
            return nil
        }
        
        return await withCheckedContinuation { continuation in
            _ = ImageLoader.shared.loadImage(from: url) { image in
                continuation.resume(returning: image)
            }
        }
    }
}
