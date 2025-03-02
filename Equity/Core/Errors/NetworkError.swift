//
//  NetworkError.swift
//  Equity
//
//  Created by ANDELA on 01/03/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingError(DecodingError)
    case requestFailed(Error)
    case unknownError
}
