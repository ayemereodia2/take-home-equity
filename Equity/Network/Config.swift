//
//  Config.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation
/*
 Plist Approach: Values are in Info.plist, which is better than hardcoded but still bundled in the app.

 JSON Approach: Config.json can be injected at build time (e.g., via CI/CD), keeping secrets out of source control.
  Also, Config.json can be loaded from a secure key server.
 */

struct Config {
    static var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String ?? ""
    }
    
    static var apiKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    }
}

struct ConfigMain {
    struct API: Codable {
        let baseURL: URL
        let apiKey: String
        
        enum CodingKeys: String, CodingKey {
            case baseURL = "baseURL"
            case apiKey = "apiKey"
        }
    }
    
    private static let config: [String: API] = {
        guard let url = Bundle.main.url(forResource: "Config", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONDecoder().decode([String: API].self, from: data) else {
            fatalError("Failed to load Config.json")
        }
        return json
    }()
    
    static var current: API {
        let envKey = Environment.current.rawValue.lowercased()
        guard let apiConfig = config[envKey] else {
            fatalError("No config found for environment: \(envKey)")
        }
        return apiConfig
    }
    
    static var baseURL: URL { current.baseURL }
    static var apiKey: String { current.apiKey }
}

enum Environment: String {
    case development = "Development"
    case staging = "Staging"
    case production = "Production"
    
    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}
