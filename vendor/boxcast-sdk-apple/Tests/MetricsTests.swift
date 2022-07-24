//
//  MetricsTests.swift
//  BoxCast
//
//  Created by Camden Fullmer on 5/15/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import XCTest
import CoreMedia
@testable import BoxCast

class MetricsTests: XCTestCase {
    
    func testMaintainsViewerId() {
        let defaults = UserDefaults.boxCastDefaults
        defaults?.removeObject(forKey: "viewerId")
        
        let broadcast = Broadcast(id: "1", name: "Test", description: "A test broadcast.",
                                  thumbnailURL: URL(string: "http://localhost")!, startDate: Date(),
                                  stopDate: Date(), channelId: "1")
        let broadcastView = BroadcastView(status: .live)
        let mc1 = MetricsConsumer(broadcast: broadcast, broadcastView: broadcastView)
        let mc2 = MetricsConsumer(broadcast: broadcast, broadcastView: broadcastView)
        XCTAssertEqual(mc1.viewerId, mc2.viewerId)
    }
    
    func testGeneratesUniqueViewId() {
        let broadcast = Broadcast(id: "1", name: "Test", description: "A test broadcast.",
                                  thumbnailURL: URL(string: "http://localhost")!, startDate: Date(),
                                  stopDate: Date(), channelId: "1")
        let broadcastView = BroadcastView(status: .live)
        let mc1 = MetricsConsumer(broadcast: broadcast, broadcastView: broadcastView)
        let mc2 = MetricsConsumer(broadcast: broadcast, broadcastView: broadcastView)
        XCTAssertNotEqual(mc1.viewId, mc2.viewId)
    }
    
    func testMetricsEndpoint() {
        let broadcast = Broadcast(id: "1", name: "Test", description: "A test broadcast.",
                                  thumbnailURL: URL(string: "http://localhost")!, startDate: Date(),
                                  stopDate: Date(), channelId: "1")
        let broadcastView = BroadcastView(status: .live)
        let mc = MetricsConsumer(broadcast: broadcast, broadcastView: broadcastView)
        XCTAssertEqual(mc.metricsURL, "https://metrics.boxcast.com")
    }
    
    func testConsumesPlay() {
        let broadcast = Broadcast(id: "1", name: "Test", description: "A test broadcast.",
                                  thumbnailURL: URL(string: "http://localhost")!, startDate: Date(),
                                  stopDate: Date(), channelId: "1", accountId: "1")
        let broadcastView = BroadcastView(status: .live)
        let expectation = self.expectation(description: "ConsumesPlay")
        
        // Add handler to get the requested data.
        var requestData: Data?
        MockedURLProtocol.requestDataHandler = { data in
            requestData = data
            expectation.fulfill()
        }
        
        // Mock manager
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(MockedURLProtocol.self, at: 0)
        
        // Create consumer and consume a metric.
        let mc = MetricsConsumer(broadcast: broadcast, broadcastView: broadcastView,
                                 configuration: configuration)
        let metric = Metric(action: .play, time: CMTime(seconds: 5, preferredTimescale: 60),
                            totalTime: CMTime(seconds: 10, preferredTimescale: 60),
                            videoHeight: 720)
        mc.consume(metric: metric)
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNotNil(requestData)
            do {
                if let data = requestData,
                    let dict = try JSONSerialization.jsonObject(with: data,
                                                                options: [.allowFragments])
                        as? [String : Any] {
                    XCTAssertEqual(dict["broadcast_id"] as? String, "1")
                    XCTAssertEqual(dict["channel_id"] as? String, "1")
                    XCTAssertEqual(dict["account_id"] as? String, "1")
                    XCTAssertEqual(dict["action"] as? String, "play")
                    XCTAssertEqual(dict["is_live"] as? Bool, true)
                    XCTAssertEqual(dict["position"] as? Double, 5)
                    XCTAssertEqual(dict["duration"] as? Double, 10)
                    XCTAssertNotNil(dict["timestamp"] as? String)
                    XCTAssertNotNil(dict["view_id"] as? String)
                    XCTAssertNotNil(dict["viewer_id"] as? String)
                    XCTAssertEqual(dict["videoHeight"] as? Int, 720)
                } else {
                    XCTFail()
                }
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
}

class MockedMetricsConsumer: MetricsConsumer {
    override func consume(metric: Metric) {
        
    }
}
