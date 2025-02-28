//
//  ImageLoader.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import UIKit
import SVGKit

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
          guard let self = self, let data = data, error == nil else {
            DispatchQueue.main.async { completion(nil) }
            return
          }
          
          var image: UIImage?
          if url.pathExtension.lowercased() == "svg" {
            // Handle SVG
            let svgImage = SVGKImage(data: data)
            /*if let svgImage = SVGKImage(data: data), svgImage.size.width > 0, svgImage.size.height > 0 {
                image = svgImage.uiImage // Safe to convert
            } else {
                print("SVGKImage has an invalid size:", url.absoluteString)
            }*/

            //used UIGraphicsImageRenderer to fix svg crash
            // a modern, efficient, and safer way to draw graphics and generate images in iOS
            
            let renderer = UIGraphicsImageRenderer(size: svgImage?.size ?? CGSize(width: 40, height: 40))
            let uiImage = renderer.image { _ in
              svgImage?.uiImage.draw(in: CGRect(origin: .zero, size: svgImage?.size ?? CGSize(width: 40, height: 40)))
              
            }
            image = uiImage
            

          } else {
            // Handle raster images
            image = UIImage(data: data)
          }
          
          guard let finalImage = image else {
            DispatchQueue.main.async { completion(nil) }
            return
          }
          
          // cache image
          self.cache.setObject(finalImage, forKey: url.absoluteString as NSString)
          // return on main thread
          DispatchQueue.main.async { completion(finalImage) }
        }
        task.resume()
        return task
    }
    
    func cancel(task: URLSessionDataTask?) {
        task?.cancel()
    }
}
