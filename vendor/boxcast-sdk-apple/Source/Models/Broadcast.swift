//
//  Broadcast.swift
//  BoxCast
//
//  Created by Camden Fullmer on 5/13/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import Foundation

/// The struct that represents a BoxCast broadcast.
public struct Broadcast {
    
    /// The unique identifier for the broadcast.
    public let id: String
    
    /// The name of the broadcast.
    public let name: String
    
    /// The description of the broadcast.
    public let description: String
    
    /// The image URL for the thumbnail of the broadcast.
    public let thumbnailURL: URL?
    
    /// The channel's unique identifier that includes this broadcast.
    public let channelId: String
    
    /// The start date of the broadcast.
    public let startDate: Date
    
    /// The stop date of the broadcast.
    public let stopDate: Date
    
    let accountId: String?
    
    init(id: String, name: String, description: String, thumbnailURL: URL, startDate: Date, stopDate: Date, channelId: String, accountId: String?=nil) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnailURL = thumbnailURL
        self.startDate = startDate
        self.stopDate = stopDate
        self.channelId = channelId
        self.accountId = accountId
    }
    
    init(channelId: String, json: Any) throws {
        guard let dict = json as? Dictionary<String, Any> else {
            throw BoxCastError.serializationError
        }
        guard
            let id = dict["id"] as? String,
            let name = dict["name"] as? String,
            let description = dict["description"] as? String,
            let startDateString = dict["starts_at"] as? String,
            let stopDateString = dict["stops_at"] as? String else {
                throw BoxCastError.serializationError
        }
        guard
            let startDate = _BoxCastDateFormatter.date(from: startDateString),
            let stopDate = _BoxCastDateFormatter.date(from: stopDateString) else {
                throw BoxCastError.serializationError
        }
        self.id = id
        self.accountId = dict["account_id"] as? String
        self.channelId = channelId
        self.name = name
        self.description = description
        self.startDate = startDate
        self.stopDate = stopDate
        self.thumbnailURL = URL(string: (dict["preview"] as? String ?? ""))
    }
    
}

public typealias BroadcastList = [Broadcast]

extension Array where Element == Broadcast {
    init(channelId: String, json: Any) throws {
        guard let array = json as? Array<Any> else {
            throw BoxCastError.serializationError
        }
        let broadcasts = try array.compactMap { json in
            return try Broadcast(channelId: channelId, json: json)
        }
        self.init(broadcasts)
    }
}
