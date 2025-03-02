//
//  NetworkService.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import Foundation
import Combine


// MARK: - Network Service Protocol
protocol NetworkService {
  func fetch<T: Decodable>(
      endpoint: APIEndpoint,
      responseType: T.Type
  ) -> AnyPublisher<T, NetworkError>
  
  func fetchCoins(offset: Int, limit: Int) -> AnyPublisher<CoinResponse, NetworkError>
}

extension URLSession: NetworkSession {}

protocol NetworkSession {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

// MARK: - API Service Implementation
class APIService: NetworkService {
    private let baseURL: URL
    private let apiKey: String
    private let session: NetworkSession

    
    init(
        baseURL: URL = URL(string: Config.baseURL)!,
        session: NetworkSession = URLSession.shared,
        apiKey: String = Config.apiKey
    ) {
        self.baseURL = baseURL
        self.session = session
        self.apiKey = apiKey
    }
  
  func fetch<T: Decodable>(
      endpoint: APIEndpoint,
      responseType: T.Type
  ) -> AnyPublisher<T, NetworkError> {
      guard let url = endpoint.url(baseURL: baseURL) else {
          return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
      }

      var request = URLRequest(url: url)
      request.setValue(apiKey, forHTTPHeaderField: "x-access-token")

      return session.dataTaskPublisher(for: request)
          .tryMap { data, response in
              guard let httpResponse = response as? HTTPURLResponse else {
                  throw NetworkError.invalidResponse(statusCode: 0)
              }
              guard (200...299).contains(httpResponse.statusCode) else {
                  throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
              }
              return data
          }
          .decode(type: T.self, decoder: JSONDecoder())
          .mapError { error in
              switch error {
              case let decodingError as DecodingError:
                  return NetworkError.decodingError(decodingError)
              case let urlError as URLError:
                  return NetworkError.requestFailed(urlError)
              default:
                  return NetworkError.requestFailed(error)
              }
          }
          .receive(on: DispatchQueue.main)
          .eraseToAnyPublisher()
  }
  
  func fetchCoins(offset: Int, limit: Int) -> AnyPublisher<CoinResponse, NetworkError> {
    
    return fetch(endpoint: .coins(offset: offset, limit: limit), responseType: CoinResponse.self)
  }
}
