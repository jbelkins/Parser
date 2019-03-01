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
        } else if let json = parser.json, let decodable = try? Self.init(from: _ObjectDecoder(jsonObject: json)) {
            self = decodable
        } else {
            let error = ParseError(path: parser.nodePath, actual: parser.node.castableJSONTypes)
            parser.recordError(error)
            return nil
        }
    }
}
