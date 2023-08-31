//
//  NetworkRequest.swift
//  CCMNetwork
//
//  Created by Alexandre Cardoso on 30/08/23.
//

protocol NetworkRequest {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var queryItems: [String: String]? { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
}

extension NetworkRequest {
    var scheme: String {
        "http"
    }

    var host: String {
        "mentoria.codandocommoa.com.br"
    }
}

enum HTTPMethod: String {
    case GET
}
