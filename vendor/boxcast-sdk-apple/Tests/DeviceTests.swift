//
//  DeviceTests.swift
//  BoxCast
//
//  Created by Camden Fullmer on 5/17/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import XCTest
@testable import BoxCast

class DeviceTests: XCTestCase {
    
    func testModelIdentifier() {
        XCTAssertNotEqual(Device.modelIdentifierString, "Unknown")
    }
    
}
