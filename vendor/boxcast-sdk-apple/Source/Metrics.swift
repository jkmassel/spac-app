//
//  Metrics.swift
//  BoxCast
//
//  Created by Camden Fullmer on 5/14/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import Foundation
import CoreMedia

struct Metric {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }()
    
    enum Action {
        case setup
        case play
        case pause
        case buffer
        case seek(toTime: CMTime)
        case time
        case complete
    }
    
    let action: Action
    let time: CMTime
    let totalTime: CMTime
    let timestamp: Date
    let videoHeight: Int
    
    init(action: Action, time: CMTime, totalTime: CMTime, videoHeight: Int) {
        self.action = action
        self.time = time
        self.totalTime = totalTime
        self.videoHeight = videoHeight
        self.timestamp = Date()
    }
    
}

protocol JSONDeserializable {
    func deserialized() -> [String : Any]
}

extension Metric.Action: JSONDeserializable {
    func deserialized() -> [String : Any] {
        var params: [String : Any] = [:]
        switch self {
        case .setup:
            params["action"] = "setup"
            params["user_agent"] = "\(InfoPlist.appName)/\(InfoPlist.appVersion) (\(InfoPlist.appBundleIndentifier); build:\(InfoPlist.appBuild); \(System.osName) \(System.osVersion)) BoxCast SDK/\(InfoPlist.boxCastSDKVersion)"
            params["platform"] = System.osName
            params["browser_name"] = System.osName
            params["os"] = System.osName
            params["browser_version"] = System.osVersion
            params["model"] = Device.modelIdentifierString
            params["product_type"] = ""
            params["system_version"] = System.osVersion
            params["vendor_identifier"] = ""
            params["player_version"] = InfoPlist.boxCastSDKVersion
            params["host"] = "\(InfoPlist.appName) for \(System.osName)"
            params["language"] = ""
            params["remote_ip"] = ""
        case .play: params["action"] = "play"
        case .pause: params["action"] = "pause"
        case .buffer: params["action"] = "buffer"
        case .seek(let toTime):
            params["action"] = "seek"
            params["offset"] = toTime.seconds
        case .time: params["action"] = "time"
        case .complete: params["action"] = "complete"
        }
        return params
    }
}

extension Metric: JSONDeserializable {
    func deserialized() -> [String : Any] {
        var params: [String : Any] = [
            "position": time.seconds,
            "duration": totalTime.seconds,
            "timestamp": Metric.dateFormatter.string(from: timestamp),
            "videoHeight": videoHeight,
            ]
        action.deserialized().forEach { params[$0] = $1 }
        return params
    }
}

extension Metric: CustomStringConvertible {
    var description: String {
        return "action: \(action.description), time: \(time.seconds), totalTime: \(totalTime.seconds)"
    }
}

extension Metric.Action: CustomStringConvertible {
    var description: String {
        switch self {
        case .setup: return "setup"
        case .play: return "play"
        case .pause: return "pause"
        case .buffer: return "buffer"
        case .seek(let toTime): return "seek (to \(toTime.seconds))"
        case .time: return "time"
        case .complete: return "complete"
        }
    }
}

class MetricsConsumer {

    let metricsURL = "https://metrics.boxcast.com"
    let headers = [
        "Accept" : "application/json"
    ]
    let appName: String
    let session: URLSession
    let broadcast: Broadcast
    let broadcastView: BroadcastView
    let viewId: String
    
    // MARK: - Lifecycle
    
    convenience init(broadcast: Broadcast, broadcastView: BroadcastView) {
        let configuration = URLSessionConfiguration.default
        self.init(broadcast: broadcast, broadcastView: broadcastView, configuration: configuration)
    }
    
    init(broadcast: Broadcast, broadcastView: BroadcastView, configuration: URLSessionConfiguration) {
        self.broadcast = broadcast
        self.broadcastView = broadcastView
        session = URLSession(configuration: configuration)
        appName = InfoPlist.appName
        viewId = UUID().uuidString
    }
    
    // MARK: - Internal
    
    func consume(metric: Metric) {
        guard let accountId = broadcast.accountId else {
            print("there is no account id, broadcast was not detailed")
            return
        }
        
        var params: [String: Any] = [
            // ???: If the status was "stalled" wouldn't this incorrectly report is_live = false
            "is_live" : broadcastView.status == .live,
            "account_id" : accountId,
            "broadcast_id" : broadcast.id,
            "channel_id" : broadcast.channelId,
            "view_id" : viewId,
            "viewer_id" : viewerId,
        ]
        metric.deserialized().forEach { params[$0] = $1 }
        postJSON(url: "\(metricsURL)/player/interaction", parameters: params) { success, error in
            if let error = error {
                print("error posting metric: \(error.localizedDescription)")
            }
        }
    }
    
    var viewerId: String {
        guard let defaults = UserDefaults.boxCastDefaults else {
            return UUID().uuidString
        }
        if let id = defaults.string(forKey: "viewerId") {
            return id
        } else {
            let id = UUID().uuidString
            defaults.set(id, forKey: "viewerId")
            return id
        }
    }
    
    // MARK: - Private
    
    private func postJSON(url: String, parameters: [String: Any], completionHandler: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: url) else {
            return completionHandler(false, BoxCastError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            completionHandler(false, error)
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async { completionHandler(false, error) }
                return
            }
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async { completionHandler(false, BoxCastError.unknown) }
                return
            }
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                // TODO parse JSON for error object.
                DispatchQueue.main.async { completionHandler(false, BoxCastError.unknown) }
                return
            }
            DispatchQueue.main.async { completionHandler(true, nil) }
        }
        task.resume()
    }
}

