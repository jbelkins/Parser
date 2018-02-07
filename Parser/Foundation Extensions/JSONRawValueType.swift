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
        guard parser.json != nil else {
            let error = ParseError(path: parser.path, message: "Nil value")
            parser.errorTarget?.receiveErrors([error])
            return nil
        }
        guard let value = parser.json as? Self else {
            let error = ParseError(path: parser.path, message: "Not a \(Self.self)")
            parser.errorTarget?.receiveErrors([error])
            return nil
        }
        self = value
    }
}
