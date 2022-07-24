//
//  Formatters.swift
//  BoxCast
//
//  Created by Camden Fullmer on 7/28/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import Foundation

public class BoxCastDateFormatter : DateFormatter {
    // Sample date string from server: 2013-04-28T23:00:00Z
    let format = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    public override init() {
        super.init()
        self.timeZone = TimeZone(secondsFromGMT: 0)
        self.locale = Locale(identifier: "en_US_POSIX")
        self.dateFormat = format
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
}

let _BoxCastDateFormatter = BoxCastDateFormatter()
