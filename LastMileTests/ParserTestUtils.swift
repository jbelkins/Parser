//
//  ParserTestUtils.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/15/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation
import LastMile


extension Array where Element == APICodingKey {

    var strings: [String] {
        return map { $0.stringValue }
    }
}
