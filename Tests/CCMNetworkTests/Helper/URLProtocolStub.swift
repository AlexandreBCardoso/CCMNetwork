//
//  URLProtocolStub.swift
//  CCMNetworkTests
//
//  Created by Alexandre Cardoso on 31/08/23.
//

import Foundation

final class URLProtocolStub: URLProtocol {
    static var requestHandler: ((URLRequest) -> (Data?, URLResponse?, Error?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func stopLoading() { }
    
    override func startLoading() {
        guard let handler = URLProtocolStub.requestHandler else { return }
        let (data, response, error) = handler(request)
        
        setURLProtocolErrorReceiveLoad(error: error, receive: response, load: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    private func setURLProtocolErrorReceiveLoad(error: Error?, receive: URLResponse?, load: Data?) {
        if let error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        if let receive {
            client?.urlProtocol(self, didReceive: receive, cacheStoragePolicy: .notAllowed)
        }
        if let load {
            client?.urlProtocol(self, didLoad: load)
        }
    }

}
