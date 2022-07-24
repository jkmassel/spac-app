//
//  String.swift
//  BoxCast
//
//  Created by Camden Fullmer on 9/26/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import Foundation

extension String {
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed)
    }
}
