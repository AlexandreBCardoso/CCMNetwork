//
//  NetworkRequestMapper.swift
//  CCMNetwork
//
//  Created by Alexandre Cardoso on 30/08/23.
//

import Foundation

struct NetworkRequestMapper {

    static func map(from request: NetworkRequest) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = request.scheme
        urlComponents.host = request.host
        urlComponents.path = request.path
        urlComponents.queryItems = request.queryItems?.compactMap { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        if let url = urlComponents.url {
            var urlRequest = URLRequest(url: url)
            urlRequest.allHTTPHeaderFields = request.headers
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.httpBody = request.body
            return urlRequest
        } else {
            return nil
        }
    }

}
