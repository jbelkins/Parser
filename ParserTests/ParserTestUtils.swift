//
//  ParserTestUtils.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/15/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation
@testable import Parser


extension Array where Element == PathNode {

    var strings: [String] {
        return map { $0.stringValue }
    }
}
