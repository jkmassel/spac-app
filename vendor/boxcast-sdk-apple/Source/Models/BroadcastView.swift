//
//  BroadcastView.swift
//  BoxCast
//
//  Created by Camden Fullmer on 5/13/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import Foundation

/// The struct that represents a view of the BoxCast broadcast.
public struct BroadcastView {

    /// Enum representing the status of the view.
    public enum Status {
        case upcoming
        case preparing
        case prepared
        case catchingUp
        case stalled
        case stalledLive
        case live
        case notRecorded
        case processingRecording
        case recorded
    }
    
    /// The status of the view.
    public let status: Status

    let playlistURL: URL?
    
    init(status: Status, playlistURL: URL?=nil) {
        self.status = status
        self.playlistURL = playlistURL
    }
    
    init(json: Any) throws {
        guard let dict = json as? Dictionary<String, Any> else {
            throw BoxCastError.serializationError
        }
        guard let statusString = dict["status"] as? String else {
                throw BoxCastError.serializationError
        }
        var playlistURL: URL?
        if let playlistURLString = dict["playlist"] as? String {
            playlistURL = URL(string: playlistURLString)
        }
        
        var status: Status
        switch statusString {
        case "upcoming": status = .upcoming
        case "preparing": status = .preparing
        case "prepared": status = .prepared
        case "catching_up": status = .catchingUp
        case "stalled_live": status = .stalledLive
        case _ where statusString.contains("stalled"): status = .stalled
        case "live": status = .live
        case "not_recorded": status = .notRecorded
        case "processing_recording": status = .processingRecording
        case "recorded": status = .recorded
        default: throw BoxCastError.serializationError
        }
        self.status = status
        self.playlistURL = playlistURL
    }
    
}
