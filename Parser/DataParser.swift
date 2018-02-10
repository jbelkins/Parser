//
//  DataParser.swift
//  Parser
//
//  Created by Josh Elkins on 2/7/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


open class DataParser {
    public var errors = [ParseError]()

    public init() {}

    public func parse<ParsedType: Parseable>(data: Data, to type: ParsedType.Type) throws -> ParsedType? {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        let rootNode = PathNode(hashKey: "root", swiftType: nil)
        let parser = Parser(node: rootNode, json: json, isRequired: true, parent: nil)
        let result = parser.optional(type)
        errors = parser.errors
        return result
    }
}
