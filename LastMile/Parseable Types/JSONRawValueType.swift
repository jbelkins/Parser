//
//  JSONRawValueType.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


protocol JSONRawValueType: Parseable {}


extension JSONRawValueType {

    public init?(parser: Parser) {
        guard let value = parser.json as? Self else {
            let error = ParseError(path: parser.nodePath, actual: parser.node.castableJSONTypes)
            parser.recordError(error)
            return nil
        }
        self = value
    }
}
