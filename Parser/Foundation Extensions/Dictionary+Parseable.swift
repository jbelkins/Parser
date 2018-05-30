//
//  Dictionary+Parseable.swift
//  Parser
//
//  Created by Josh Elkins on 5/30/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension Dictionary: Parseable where Key == String, Value: Parseable {
    public static var idKey: String? { return nil }
    public static var jsonType: JSONElement { return .object }

    public var parseableElementCount: Int? { return count }

    public init?(parser: Parser) {
        guard let jsonDict = parser.json as? [String: Any] else {
            let message = "Not a Dict, casts to \(parser.node.castableJSONTypes.map { $0.rawValue }.joined(separator: ", "))"
            parser.recordError(ParseError(path: parser.path, message: message))
            return nil
        }
        let parsed: [(String, Value)?] = jsonDict.map { (key, json) -> (String, Value)? in
            guard let value = parser[key].required(Value.self) else { return nil }
            return (key, value)
        }
        let pairs = parsed.filter { $0 != nil }.map { $0! }
        self = Dictionary(pairs, uniquingKeysWith: { a, b in return a })
    }
}
