//
//  DataParser.swift
//  Parser
//
//  Created by Josh Elkins on 2/7/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


open class DataParser: ErrorTarget {
    public var errors = [ParseError]()
    private var parser: Parser

    public init(data: Data) throws {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        let path = [PathNode(hashKey: "root", swiftType: nil)]
        parser = Parser(path: path, json: json, isRequired: true)
    }

    public func parse<ParsedType: Parseable>(_ type: ParsedType.Type) -> ParsedType? {
        parser.errorTarget = self
        return parser.optional(type)
    }

    public func receiveErrors(_ receivedErrors: [ParseError]) {
        errors += receivedErrors
    }
}
