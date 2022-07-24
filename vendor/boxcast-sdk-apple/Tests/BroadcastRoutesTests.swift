//
//  BroadcastRoutesTests.swift
//  BoxCast
//
//  Created by Camden Fullmer on 8/17/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import XCTest
@testable import BoxCast

class BroadcastRoutesTests: MockedClientTestCase {
    
    func testGetLiveBroadcasts() {
        guard let data = fixtureData(for: "LiveBroadcasts") else {
            XCTFail("no fixture data")
            return
        }
        MockedURLProtocol.mockedData = data
        var url: URL?
        MockedURLProtocol.requestHandler = { request in
            url = request.url
        }
        
        let expectation = self.expectation(description: "GetLiveBroadcasts")
        var liveBroadcasts: BroadcastList?
        client.getLiveBroadcasts(channelId: "1") { broadcasts, error in
            liveBroadcasts = broadcasts
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            XCTAssertNotNil(liveBroadcasts)
            XCTAssertEqual(liveBroadcasts?.count, 1)
        }
        
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.query?.removingPercentEncoding, "q=timeframe:current timeframe:preroll")
    }
    
    func testGetArchivedBroadcasts() {
        guard let data = fixtureData(for: "ArchivedBroadcasts") else {
            XCTFail("no fixture data")
            return
        }
        MockedURLProtocol.mockedData = data
        var url: URL?
        MockedURLProtocol.requestHandler = { request in
            url = request.url
        }
        
        let expectation = self.expectation(description: "GetArchivedBroadcasts")
        var archivedBroadcasts: BroadcastList?
        client.getArchivedBroadcasts(channelId: "1") { broadcasts, error in
            archivedBroadcasts = broadcasts
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            XCTAssertNotNil(archivedBroadcasts)
            XCTAssertEqual(archivedBroadcasts?.count, 1)
        }
        
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.query?.removingPercentEncoding, "q=timeframe:past")
    }
    
    func testGetBroadcast() {
        let formatter = BoxCastDateFormatter()
        let startDate = formatter.date(from: "2017-07-28T22:00:00Z") ?? Date()
        let stopDate = formatter.date(from: "2017-07-28T23:00:00Z") ?? Date()
        guard let data = fixtureData(for: "Broadcast") else {
            XCTFail("no fixture data")
            return
        }
        MockedURLProtocol.mockedData = data
        
        let expectation = self.expectation(description: "GetLiveBroadcasts")
        var broadcast: Broadcast?
        client.getBroadcast(broadcastId: "1", channelId: "2") { b, error in
            broadcast = b
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            XCTAssertNotNil(broadcast)
            XCTAssertEqual(broadcast?.id, "1")
            XCTAssertEqual(broadcast?.accountId, "1")
            XCTAssertEqual(broadcast?.channelId, "2")
            XCTAssertEqual(broadcast?.name, "Test")
            XCTAssertEqual(broadcast?.description, "A test broadcast.")
            XCTAssertEqual(broadcast?.thumbnailURL, URL(string: "https://api.boxcast.com/thumbnail.jpg")!)
            XCTAssertTrue(broadcast?.startDate.compare(startDate) == .orderedSame)
            XCTAssertTrue(broadcast?.stopDate.compare(stopDate) == .orderedSame)
        }
    }
    
}
