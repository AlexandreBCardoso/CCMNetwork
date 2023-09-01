//
//  URLSessionNetworkClient.swift
//  CCMNetwork
//
//  Created by Alexandre Cardoso on 30/08/23.
//

import Foundation

public final class URLSessionNetworkClient: NetworkClient {
    
    private let client: URLSession
    
    public init(client: URLSession = URLSession.shared) {
        self.client = client
    }

    public func execute(_ networkRequest: NetworkRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let urlRequest = NetworkRequestMapper.map(from: networkRequest) else {
            return completion(.failure(.invalidURL))
        }
        
        let task = client.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                return completion(.failure(.networkError))
            }
            
            guard let response = (response as? HTTPURLResponse) else {
                return completion(.failure(.networkError))
            }

            if !((200..<300) ~= response.statusCode) {
                return completion(.failure(.invalidStatusCode))
            }
            
            if let data, data != Data() {
                completion(.success(data))
            } else {
                return completion(.failure(.noData))
            }

        }
        task.resume()
    }
    
}
