//
//  NetworkRequestMapperTestCase.swift
//  CCMNetworkTests
//
//  Created by Alexandre Cardoso on 31/08/23.
//

@testable import CCMNetwork
import XCTest

final class NetworkRequestMapperTestCase: XCTestCase {

    func test_map_validURLRequest() throws {
        let requestFake = makeNetworkRequest(
            headers: ["anyHeaderKey": "anyHeaderValue"],
            queryItems: ["anyQueryKey": "anyQueryValue"]
        )
        let urlStringExpected = "https://any.website.com.br/v1?anyQueryKey=anyQueryValue"
        let sut = NetworkRequestMapper.map(from: requestFake)
        
        XCTAssertNotNil(sut)
        XCTAssertNil(sut?.httpBody)
        XCTAssertEqual(sut?.httpMethod, "GET")
        XCTAssertEqual(sut?.allHTTPHeaderFields, ["anyHeaderKey": "anyHeaderValue"])
        XCTAssertEqual(sut?.url?.absoluteString, urlStringExpected)
    }
    
    func test_map_invalidURLRequest() {
        let requestFake = makeNetworkRequest(path: "v1")

        XCTAssertNil(NetworkRequestMapper.map(from: requestFake))
    }

}

extension NetworkRequestMapperTestCase {
    func makeNetworkRequest(
        scheme: String = "https",
        host: String = "any.website.com.br",
        path: String = "/v1",
        headers: [String: String]? = nil,
        queryItems: [String: String]? = nil,
        method: HTTPMethod = .GET,
        body: Data? = nil
    ) -> NetworkRequest {
        return NetworkRequestFake(
            scheme: scheme,
            host: host,
            path: path,
            headers: headers,
            queryItems: queryItems,
            method: method,
            body: body
        )
    }
}
