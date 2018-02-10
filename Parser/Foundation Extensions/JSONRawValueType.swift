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
        guard let nonNilJSON = parser.json else {
            let error = ParseError(path: parser.path, message: "Nil value")
            parser.recordError(error)
            return nil
        }
        guard let value = nonNilJSON as? Self else {
            let error = ParseError(path: parser.path, message: "Not a \(Self.self), is a \(type(of: nonNilJSON))")
            parser.recordError(error)
            return nil
        }
        self = value
    }
}
