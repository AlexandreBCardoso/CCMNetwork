//
//  NetworkClient.swift
//  CCMNetwork
//
//  Created by Alexandre Cardoso on 30/08/23.
//

import Foundation

public protocol NetworkClient {
    func execute(_ request: NetworkRequest, completion: @escaping(Result<Data, NetworkError>) -> Void)
}
