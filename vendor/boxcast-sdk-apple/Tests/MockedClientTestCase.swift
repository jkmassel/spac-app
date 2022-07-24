//
//  MockedClientTestCase.swift
//  BoxCast
//
//  Created by Camden Fullmer on 8/22/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import XCTest
@testable import BoxCast

class MockedClientTestCase: XCTestCase {
    
    var client: BoxCastClient!
    
    override func setUp() {
        super.setUp()
        
        // Set up mocking of the responses.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(MockedURLProtocol.self, at: 0)
        client = BoxCastClient(scope: PublicScope(), configuration: configuration)
    }
    
    func fixtureData(for name: String) -> Data? {
        let bundle = Bundle(for: MockedClientTestCase.self)
        
        guard let resourceURL = bundle.resourceURL else {
            return nil
        }
        
        let fileManager = FileManager.default
        let fileURL = resourceURL.appendingPathComponent("\(name).json")
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            return nil
        }
    }
}
