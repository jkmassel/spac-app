//
//  QueryBuilderTests.swift
//  BoxCast
//
//  Created by Camden Fullmer on 5/16/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import XCTest
@testable import BoxCast

class QueryBuilderTests: XCTestCase {
    
    func testAnd() {
        let builder = QueryBuilder()
        builder.appendWithLogic(.or, key: "key", value: "this")
        builder.appendWithLogic(.and, key: "key", value: "that")
        XCTAssertEqual(builder.build(), "key:this +key:that")
    }
    
    func testOr() {
        let builder = QueryBuilder()
        builder.appendWithLogic(.or, key: "key", value: "this")
        builder.appendWithLogic(.or, key: "key", value: "that")
        XCTAssertEqual(builder.build(), "key:this key:that")
    }
    
}
