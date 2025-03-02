//
//  MockNetworkService.swift
//  EquityTests
//
//  Created by ANDELA on 01/03/2025.
//

import Foundation
import Combine
@testable import Equity

class MockNetworkService: NetworkService {
    var shouldReturnError = false
    var mockCoinResponse: CoinResponse?
    var stubbedFetchCoinsResult: AnyPublisher<CoinResponse, NetworkError>!

    func fetch<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        if shouldReturnError {
            return Fail(error: NetworkError.requestFailed(NSError(domain: "TestError", code: -1)))
                .eraseToAnyPublisher()
        }
        
        if let response = mockCoinResponse as? T {
            return Just(response)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
    }
    
    func fetchCoins(offset: Int, limit: Int) -> AnyPublisher<CoinResponse, NetworkError> {
        if shouldReturnError {
            return Fail(error: NetworkError.requestFailed(NSError(domain: "TestError", code: -1)))
                .eraseToAnyPublisher()
        }
        
        if let response = mockCoinResponse {
            return Just(response)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
    }
}
