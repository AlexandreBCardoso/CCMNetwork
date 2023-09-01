//
//  NetworkRequestFake.swift
//  CCMNetworkTests
//
//  Created by Alexandre Cardoso on 31/08/23.
//

import Foundation
import CCMNetwork

struct NetworkRequestFake: NetworkRequest {
    let scheme: String
    let host: String
    let path: String
    let headers: [String: String]?
    let queryItems: [String: String]?
    let method: CCMNetwork.HTTPMethod
    let body: Data?
}
