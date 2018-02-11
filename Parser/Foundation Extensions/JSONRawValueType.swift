//
//  JSONRawValueType.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


protocol JSONRawValueType {}


extension JSONRawValueType {

    public init?(parser: Parser) {
        guard let value = parser.json as? Self else { return nil }
        self = value
    }
}
