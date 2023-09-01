//
//  URLSessionNetworkClientTestCase.swift
//  CCMNetworkTests
//
//  Created by Alexandre Cardoso on 31/08/23.
//

@testable import CCMNetwork
import XCTest

final class URLSessionNetworkClientTestCase: XCTestCase {

    func test_execute_networkErrorGeneric() {
        let expectation = expectation(description: "URLSession.execute")
        let (requestFake, _) = makeNetworkRequest()
        let sut = makeSUT()
        
        makeRequestHandler(error: NSError(domain: "any error", code: -1))
        
        sut.execute(requestFake) { result in
            switch result {
                case .success:
                    XCTFail("Error should fall into failure")
                case let .failure(response):
                    XCTAssertEqual(response, .networkError)
                    XCTAssertEqual(response.errorDescription, "An error has occurred. Please verify your connection.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_execute_networkError() {
        let expectation = expectation(description: "URLSession.execute")
        let (requestFake, _) = makeNetworkRequest()
        let sut = makeSUT()
        
        makeRequestHandler()
        
        sut.execute(requestFake) { result in
            switch result {
                case .success:
                    XCTFail("Error should fall into failure")
                case let .failure(response):
                    XCTAssertEqual(response, .networkError)
                    XCTAssertEqual(response.errorDescription, "An error has occurred. Please verify your connection.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_execute_invalidURL() throws {
        let expectation = expectation(description: "URLSession.execute")
        let (requestFake, _) = makeNetworkRequest(path: "v1")
        let sut = makeSUT()

        makeRequestHandler()

        sut.execute(requestFake) { result in
            switch result {
                case .success:
                    XCTFail("Error should fall into failure")
                case let .failure(response):
                    XCTAssertEqual(response, .invalidURL)
                    XCTAssertEqual(response.errorDescription, "Invalid URL")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_execute_successWithStatusCode200() throws {
        let expectation = expectation(description: "URLSession.execute")
        let (requestFake, urlRequest) = makeNetworkRequest()
        let url = try XCTUnwrap(urlRequest?.url)
        let dataExpected = makeData()
        let sut = makeSUT()
        
        makeRequestHandler(data: makeData(), url: url, statusCode: 200)
        
        sut.execute(requestFake) { result in
            switch result {
                case let .success(response):
                    XCTAssertEqual(response, dataExpected)
                case .failure:
                    XCTFail("Error should fall into success")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_execute_successWithStatusCode299() throws {
        let expectation = expectation(description: "URLSession.execute")
        let (requestFake, urlRequest) = makeNetworkRequest()
        let url = try XCTUnwrap(urlRequest?.url)
        let dataExpected = makeData()
        let sut = makeSUT()
        
        makeRequestHandler(data: makeData(), url: url, statusCode: 299)
        
        sut.execute(requestFake) { result in
            switch result {
                case let .success(response):
                    XCTAssertEqual(response, dataExpected)
                case .failure:
                    XCTFail("Error should fall into success")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_execute_invalidStatusCode() throws {
        let expectation = expectation(description: "URLSession.execute")
        let (requestFake, urlRequest) = makeNetworkRequest()
        let url = try XCTUnwrap(urlRequest?.url)
        let sut = makeSUT()
        
        makeRequestHandler(data: Data(), url: url, statusCode: 300)
        
        sut.execute(requestFake) { result in
            switch result {
                case .success:
                    XCTFail("Error should fall into failure")
                case let .failure(response):
                    XCTAssertEqual(response, .invalidStatusCode)
                    XCTAssertEqual(response.errorDescription, "Invalid status code")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_execute_noData() throws {
        let expectation = expectation(description: "URLSession.execute")
        let (requestFake, urlRequest) = makeNetworkRequest()
        let url = try XCTUnwrap(urlRequest?.url)
        let sut = makeSUT()
        
        makeRequestHandler(url: url, statusCode: 299)
        
        sut.execute(requestFake) { result in
            switch result {
                case .success:
                    XCTFail("Error should fall into failure")
                case let .failure(response):
                    XCTAssertEqual(response, .noData)
                    XCTAssertEqual(response.errorDescription, "Data error")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

}

extension URLSessionNetworkClientTestCase {
    
    func makeSUT() -> URLSessionNetworkClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let urlSession = URLSession(configuration: configuration)

        return URLSessionNetworkClient(client: urlSession)
    }
    
    func makeNetworkRequest(
        scheme: String = "https",
        host: String = "any.website.com.br",
        path: String = "/v1",
        headers: [String: String]? = nil,
        queryItems: [String: String]? = nil,
        method: HTTPMethod = .GET,
        body: Data? = nil
    ) -> (networkRequest: NetworkRequest, urlRequest: URLRequest?) {
        let requestFake = NetworkRequestFake(
            scheme: scheme,
            host: host,
            path: path,
            headers: headers,
            queryItems: queryItems,
            method: method,
            body: body
        )
        let urlRequest = NetworkRequestMapper.map(from: requestFake)
        
        return (requestFake, urlRequest)
    }
    
    func makeRequestHandler(data: Data? = nil, url: URL? = nil, statusCode: Int? = nil, error: Error? = nil) {
        URLProtocolStub.requestHandler = { request in
            guard let url, let statusCode else {
                return (data, nil, error)
            }
            let httpURLResponse = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            ) ?? HTTPURLResponse()
            return (data, httpURLResponse, error)
        }
    }
    
    func makeData() -> Data {
        var json: String {
            return """
            { "themeId": "1" }
            """
        }
        
        return json.data(using: .utf8) ?? Data()
    }
        
}
