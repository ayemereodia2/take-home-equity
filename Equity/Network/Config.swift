//
//  Config.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation

struct Config {
    static var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String ?? ""
    }
    
    static var apiKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    }
}
