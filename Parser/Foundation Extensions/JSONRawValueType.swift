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
            parser.addError(error)
            return nil
        }
        guard let value = nonNilJSON as? Self else {
            let error = ParseError(path: parser.path, message: "Not a \(Self.self), is a \(type(of: nonNilJSON))")
            parser.addError(error)
            return nil
        }
        self = value
    }
}
