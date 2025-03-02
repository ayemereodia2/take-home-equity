//
//  APIEndpoint.swift
//  Equity
//
//  Created by ANDELA on 01/03/2025.
//

import Foundation

enum APIEndpoint {
    case coins(offset: Int, limit: Int)
    // i can easily add more cases per module.
    func url(baseURL: URL) -> URL? {
        switch self {
        case .coins(let offset, let limit):
            var components = URLComponents(url: baseURL.appendingPathComponent("coins"), resolvingAgainstBaseURL: true)
            components?.queryItems = [
                URLQueryItem(name: "offset", value: "\(offset)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
            return components?.url
        }
    }
}
