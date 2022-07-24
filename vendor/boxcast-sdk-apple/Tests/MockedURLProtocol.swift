//
//  MockedURLProtocol.swift
//  BoxCast
//
//  Created by Camden Fullmer on 5/15/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import Foundation

class MockedURLProtocol : URLProtocol {
    
    static var mockedData: Data?
    static var mockedStatusCode: Int?
    static let mockedHeaders = ["Content-Type" : "application/json; charset=utf-8"]
    static var requestHandler: ((URLRequest) -> Void)?
    static var requestDataHandler: ((Data?) -> Void)?
    
    override func startLoading() {
        let request = self.request
        
        MockedURLProtocol.requestHandler?(request)
        
        if let httpBodyStream = request.httpBodyStream {
            httpBodyStream.open()
            let bufferSize = 1024
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
            let length = httpBodyStream.read(buffer, maxLength: bufferSize)
            let httpBody = Data(bytes: buffer, count: length)
            buffer.deallocate()
            MockedURLProtocol.requestDataHandler?(httpBody)
        }
        
        let client = self.client
        let statusCode = MockedURLProtocol.mockedStatusCode ?? 200
        let response = HTTPURLResponse(url: request.url!, statusCode: statusCode,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: MockedURLProtocol.mockedHeaders)
        client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
        if let data = MockedURLProtocol.mockedData {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
        
        // Reset.
        MockedURLProtocol.mockedData = nil
        MockedURLProtocol.requestDataHandler = nil
        MockedURLProtocol.requestHandler = nil
    }
    
    override func stopLoading() {
        //noop
    }
    
    override internal class func canInit(with request: URLRequest) -> Bool {
        return request.url?.scheme == "https"
    }
    
    override internal class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
}
