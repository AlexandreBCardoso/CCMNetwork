//
//  HttpClient.swift
//  CCMNetwork
//
//  Created by Alexandre Cardoso on 30/08/23.
//

import Foundation

protocol NetworkManagerProtocol {
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    public init() { }

    public func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {}
}

class URLSessionNetworkClient: NetworkClient {
    
    let client: URLSession
    
    init(client: URLSession = URLSession.shared) {
        self.client = client
    }

    func execute(_ networkRequest: NetworkRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let urlRequest = NetworkRequestMapper.map(from: networkRequest) else {
            return completion(.failure(NSError(domain: "", code: 2)))
        }
    }
    
}
