//
//  URLSessionNetworkClient.swift
//  CCMNetwork
//
//  Created by Alexandre Cardoso on 30/08/23.
//

import Foundation

final class URLSessionNetworkClient: NetworkClient {
    
    private let client: URLSession
    
    init(client: URLSession = URLSession.shared) {
        self.client = client
    }

    func execute(_ networkRequest: NetworkRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let urlRequest = NetworkRequestMapper.map(from: networkRequest) else {
            return completion(.failure(NetworkError.invalidURL))
        }
        
        let task = client.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completion(.failure(NetworkError.networkError))
            }
            
            guard let data else {
                return completion(.failure(NetworkError.noData))
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
}
