//
//  NetworkError.swift
//  CCMNetwork
//
//  Created by Alexandre Cardoso on 30/08/23.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case networkError
    case invalidStatusCode
    case noData
}

extension NetworkError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .noData:
            return "Data error"
        case .invalidURL:
            return "Invalid URL"
        case .invalidStatusCode:
            return "Invalid status code"
        case .networkError:
            return "An error has occurred. Please verify your connection."
        }
    }
}
