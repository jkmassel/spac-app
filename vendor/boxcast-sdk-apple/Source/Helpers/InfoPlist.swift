//
//  InfoPlist.swift
//  BoxCast
//
//  Created by Camden Fullmer on 5/14/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import Foundation

class InfoPlist {
    
    static var boxCastSDKVersion: String {
        return boxCastSDKInfoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    static var appName: String {
        return appInfoDictionary?["CFBundleName"] as? String ?? "Unknown"
    }
    
    static var appVersion: String {
        return appInfoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    static var appBuild: String {
        return appInfoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    static var appBundleIndentifier: String {
        return appInfoDictionary?["CFBundleIdentifier"] as? String ?? "Unknown"
    }
    
    static var appInfoDictionary: [String : Any]? {
        return Bundle.main.infoDictionary
    }
    
    static var boxCastSDKInfoDictionary: [String : Any]? {
        return Bundle(for: InfoPlist.self).infoDictionary
    }
    
}
