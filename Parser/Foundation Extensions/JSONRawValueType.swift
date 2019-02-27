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
            let message = "Not a \(Self.self), casts to \(parser.node.castableJSONTypes.map { $0.rawValue }.joined(separator: ", "))"
            parser.recordError(ParseError(path: parser.nodePath, message: message))
            return nil
        }
        self = value
    }
}
