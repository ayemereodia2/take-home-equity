//
//  APIServiceTests.swift
//  EquityTests
//
//  Created by ANDELA on 01/03/2025.
//

import XCTest
import Combine
@testable import Equity


/*class APIServiceTests: XCTestCase {

    var apiService: APIService!
    var mockSession: MockNetworkSession!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockSession = MockNetworkSession()
        apiService = APIService(session: mockSession)
    }

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        apiService = nil
        mockSession = nil
        super.tearDown()
    }

    func testFetchCoins_Success() {
        // Arrange
        let mockData = Data()  // Replace with actual mock response data
        let expectedResponse = CoinResponse(coins: [])  // Replace with expected response

        mockSession.stubbedDataTaskPublisher = { request in
            return Just((mockData, HTTPURLResponse()))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        let endpoint = APIEndpoint.coins(offset: 0, limit: 10)

        // Act
        let resultPublisher = apiService.fetchCoins(offset: 0, limit: 10)

        resultPublisher
            .sink(receiveCompletion: { completion in
                // Assert
                switch completion {
                case .failure(let error):
                    XCTFail("Expected success, but got failure with error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                XCTAssertEqual(response.coins, expectedResponse.coins)
            })
            .store(in: &cancellables)
    }

    func testFetchCoins_Failure() {
        // Arrange
        mockSession.stubbedDataTaskPublisher = { request in
            return Fail(error: NetworkError.requestFailed(NSError(domain: "", code: -1, userInfo: nil)))
                .eraseToAnyPublisher()
        }

        let endpoint = APIEndpoint.coins(offset: 0, limit: 10)

        // Act
        let resultPublisher = apiService.fetchCoins(offset: 0, limit: 10)

        resultPublisher
            .sink(receiveCompletion: { completion in
                // Assert
                switch completion {
                case .failure(let error):
                    XCTAssertNotNil(error)
                case .finished:
                    XCTFail("Expected failure, but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but got success")
            })
            .store(in: &cancellables)
    }

    func testFetch_InvalidURL() {
        // Arrange
        let invalidEndpoint = APIEndpoint.invalid // Assuming you have an invalid endpoint case

        // Act
        let resultPublisher = apiService.fetch(endpoint: invalidEndpoint, responseType: CoinResponse.self)

        resultPublisher
            .sink(receiveCompletion: { completion in
                // Assert
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error, NetworkError.invalidURL)
                case .finished:
                    XCTFail("Expected failure, but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but got success")
            })
            .store(in: &cancellables)
    }
}

class MockNetworkSession: NetworkSession {
 
    var stubbedDataTaskPublisher: ((URLRequest) -> AnyPublisher<(Data, URLResponse), Error>)?

    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(Data, URLResponse), Error> {
        return stubbedDataTaskPublisher?(request) ?? Empty().eraseToAnyPublisher()
    }
}*/
