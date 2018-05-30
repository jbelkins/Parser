//
//  Decodable+Parseable.swift
//  Parser
//
//  Created by Josh Elkins on 2/12/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension Decodable {

    public init?(parser: Parser) {
        if let value = parser.json as? Self {
            self = value
        } else if let json = parser.json, let data = try? JSONSerialization.data(withJSONObject: json, options: []), let decodable = try? JSONDecoder().decode(Self.self, from: data) {
            self = decodable
        } else {
            let message = "Not a \(Self.self), casts to \(parser.node.castableJSONTypes.map { $0.rawValue }.joined(separator: ", "))"
            parser.recordError(ParseError(path: parser.path, message: message))
            return nil
        }
    }
}
