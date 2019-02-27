//
//  Dictionary+Parseable.swift
//  Parser
//
//  Created by Josh Elkins on 5/30/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension Dictionary: Parseable where Key == String, Value: Parseable {
    public var parseableElementCount: Int? { return count }

    public init?(parser: Parser) {
        guard let jsonDict = parser.json as? [String: Any] else {
            let message = "Not a Dict, casts to \(parser.node.castableJSONTypes.map { $0.rawValue }.joined(separator: ", "))"
            parser.recordError(ParseError(path: parser.nodePath, message: message))
            return nil
        }
        let parsed: [(String, Value)?] = jsonDict.map { (key, json) -> (String, Value)? in
            guard let value = parser[key].required(Value.self) else { return nil }
            return (key, value)
        }
        self = Dictionary(uniqueKeysWithValues: parsed.filter { $0 != nil }.map { $0! })
    }
}
