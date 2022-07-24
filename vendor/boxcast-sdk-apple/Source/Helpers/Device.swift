//
//  UIKitExtensions.swift
//  BoxCast
//
//  Created by Camden Fullmer on 5/16/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import Foundation

public struct Device {

    public static var modelIdentifierString: String {
        #if os(iOS) || os (tvOS)
            var systemInfo = utsname()
            uname(&systemInfo)
            let mirror = Mirror(reflecting: systemInfo.machine)
            
            let identifier = mirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            return identifier
        #elseif os(macOS)
            var size: Int = 0
            sysctlbyname("hw.model", nil, &size, nil, 0)
            var model: [CChar] = Array(repeating: CChar(), count: size)
            sysctlbyname("hw.model", &model, &size, nil, 0)
            return String(cString: model)
        #else
            return "Unknown"
        #endif
    }
    
}
