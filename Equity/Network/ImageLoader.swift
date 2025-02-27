//
//  ImageLoader.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        // Check cache first
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return nil
        }
        
        // Fetch asynchronously
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            // Cache the image
            self.cache.setObject(image, forKey: url.absoluteString as NSString)
            
            // Return on main thread
            DispatchQueue.main.async { completion(image) }
        }
        task.resume()
        return task
    }
    
    func cancel(task: URLSessionDataTask?) {
        task?.cancel()
    }
}
