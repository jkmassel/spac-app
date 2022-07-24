//
//  UserDefaults.swift
//  BoxCast
//
//  Created by Camden Fullmer on 5/15/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static var boxCastDefaults: UserDefaults? {
        return UserDefaults(suiteName: "com.boxcast.sdk-defaults")
    }
    
}
