//
//  NetworkService.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation
import Combine

import Combine
import Foundation

// MARK: - Network Error Handling
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case requestFailed(Error)
}

// MARK: - Network Service Protocol
protocol NetworkService {
    func fetchCoins(offset: Int, limit: Int) -> AnyPublisher<CoinResponse, NetworkError>
}

// MARK: - API Endpoint Helper
enum APIEndpoint {
    case coins(offset: Int, limit: Int)
    
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

// MARK: - API Service Implementation
class APIService: NetworkService {
    private let baseURL: URL
    private let session: URLSession
    private let apiKey: String
    
    init(
        baseURL: URL = URL(string: Config.baseURL)!,
        session: URLSession = .shared,
        apiKey: String = Config.apiKey
    ) {
        self.baseURL = baseURL
        self.session = session
        self.apiKey = apiKey
    }
    
    func fetchCoins(offset: Int, limit: Int) -> AnyPublisher<CoinResponse, NetworkError> {
        guard let url = APIEndpoint.coins(offset: offset, limit: limit).url(baseURL: baseURL) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-access-token")
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: CoinResponse.self, decoder: JSONDecoder())
            .mapError { error in
              if let decodingError = error as? DecodingError {
                print("❌ Decoding Error: \(decodingError.localizedDescription)")
                print("🔍 Detailed Decoding Error: \(decodingError)")
                return NetworkError.decodingError
              } else {
                return NetworkError.requestFailed(error)
              }
//                return (error as? DecodingError) != nil ? NetworkError.decodingError : NetworkError.requestFailed(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

