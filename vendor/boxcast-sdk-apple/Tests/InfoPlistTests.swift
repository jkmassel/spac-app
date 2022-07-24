//
//  InfoPlistTests.swift
//  BoxCast
//
//  Created by Camden Fullmer on 5/16/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import XCTest
@testable import BoxCast

class InfoPlistTests: XCTestCase {
    
    func testAppName() {
        XCTAssertEqual(InfoPlist.appName, "xctest")
    }
    
    func testAppVersion() {
        XCTAssertEqual(InfoPlist.appVersion, "Unknown")
    }
    
    func testAppBuild() {
        XCTAssertEqual(InfoPlist.appBuild, "17501")
    }
    
    func testAppBundleIdentifier() {
        XCTAssertEqual(InfoPlist.appBundleIndentifier, "com.apple.dt.xctest.tool")
    }
    
    func testBoxCastSDKVersion() {
        XCTAssertEqual(InfoPlist.boxCastSDKVersion, "0.5.2")
    }
    
}
