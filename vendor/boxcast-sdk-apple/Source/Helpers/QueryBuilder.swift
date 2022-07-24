//
//  QueryBuilder.swift
//  BoxCast
//
//  Created by Camden Fullmer on 5/13/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import Foundation

/// This class builds a query for the BoxCast API. NOTE: This query is not the same as the query for
/// a URL. This query builder is for the query key ("q") in the URL's query.
class QueryBuilder {
    
    public enum Logic : String {
        case and = "+"
        case or = ""
    }
    
    fileprivate var string : String?
    
    public init() {
        self.string = nil
    }
    
    open func appendWithLogic(_ logic: Logic, key: String, value: String) {
        if self.string == nil {
            self.string = logic.rawValue + key + ":" + value
        } else {
            self.string! += " " + logic.rawValue + key + ":" + value
        }
    }
    
    open func build() -> String {
        if let s = string {
            return s
        } else {
            return ""
        }
    }
    
}
