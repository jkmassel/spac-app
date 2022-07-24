//
//  BroadcastViewRoutes.swift
//  BoxCast
//
//  Created by Camden Fullmer on 8/17/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import Foundation

extension BoxCastClient {
    
    // MARK: - Accessing Broadcast Views
    
    /// Returns a view for a specific broadcast.
    ///
    /// - Parameters:
    ///   - broadcastId: The broadcast id.
    ///   - completionHandler: The handler to be called upon completion.
    public func getBroadcastView(broadcastId: String, completionHandler: @escaping ((BroadcastView?, Error?) -> Void)) {
        getJSON(for: "/broadcasts/\(broadcastId)/view") { (json, error) in
            if let json = json {
                do {
                    let broadcastView = try BroadcastView(json: json)
                    completionHandler(broadcastView, nil)
                } catch {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, error ?? BoxCastError.unknown)
            }
        }
    }
    
}
