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


extension PathNode: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int

    public init(integerLiteral value: PathNode.IntegerLiteralType) {
        self.init(arrayIndex: value, swiftType: nil)
    }
}


extension PathNode: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    public init(stringLiteral value: PathNode.StringLiteralType) {
        self.init(hashKey: value, swiftType: nil)
    }
}
