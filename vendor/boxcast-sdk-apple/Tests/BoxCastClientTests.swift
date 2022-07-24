//
//  BoxCastClientTests.swift
//  BoxCastTests
//
//  Created by Camden Fullmer on 5/13/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import XCTest
@testable import BoxCast

class BoxCastClientTests: MockedClientTestCase {
    
    func testApiEndpoint() {
        let client = BoxCastClient(scope: PublicScope())
        XCTAssertEqual(client.scope.apiURL, "https://api.boxcast.com")
    }
    
    func testDeleteRequest() {
        MockedURLProtocol.mockedStatusCode = 202
        
        var actualRequest: URLRequest?
        MockedURLProtocol.requestHandler = { request in
           actualRequest = request
        }
        
        let expectation = self.expectation(description: "DeleteRequest")
        
        client.delete(path: "/delete") { (response, data, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            XCTAssertEqual(0, data?.count)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertEqual(actualRequest?.httpMethod, "DELETE")
    }
    
    func testGetRequest() {
        MockedURLProtocol.mockedStatusCode = 200
        
        var actualRequest: URLRequest?
        MockedURLProtocol.requestHandler = { request in
            actualRequest = request
        }
        
        let expectation = self.expectation(description: "GetRequest")
        let parameters: [String:Any] = [
            "l": 20,
            "s": "-starts_at",
            "q": "timeframe:current",
        ]
        
        client.get(path: "/get", parameters: parameters) { (response, data, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            XCTAssertEqual(0, data?.count)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertEqual(actualRequest?.httpMethod, "GET")
        XCTAssertTrue(actualRequest!.url!.query!.removingPercentEncoding!.contains("l=20"))
        XCTAssertTrue(actualRequest!.url!.query!.removingPercentEncoding!.contains("s=-starts_at"))
        XCTAssertTrue(actualRequest!.url!.query!.removingPercentEncoding!.contains("q=timeframe:current"))
    }
    
    func testPutRequest() {
        MockedURLProtocol.mockedStatusCode = 200
        MockedURLProtocol.mockedData = try! JSONSerialization.data(withJSONObject: [:], options: [])
        
        var actualRequest: URLRequest?
        MockedURLProtocol.requestHandler = { request in
            actualRequest = request
        }
        
        let expectation = self.expectation(description: "PutRequest")
        client.putJSON(for: "/put", parameters: [:]) { (json, error) in
            XCTAssertNotNil(json)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertEqual(actualRequest?.httpMethod, "PUT")
    }
    
    func testPostRequest() {
        MockedURLProtocol.mockedStatusCode = 200
        
        var actualRequest: URLRequest?
        MockedURLProtocol.requestHandler = { request in
            actualRequest = request
        }
        
        let expectation = self.expectation(description: "PostRequest")
        client.post(path: "/post", parameters: [:]) { (response, data, error) in
            XCTAssertNotNil(response)
            XCTAssertEqual(0, data?.count)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertEqual(actualRequest?.httpMethod, "POST")
    }
    
}
