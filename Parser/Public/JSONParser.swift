//
//  JSONParser.swift
//  Parser
//
//  Created by Josh Elkins on 2/12/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public class JSONParser {

    public init() {}

    public func parse<ParsedType: Parseable>(json: Any?, to type: ParsedType.Type, options: [String: Any] = [:]) -> ParseResult<ParsedType> {
        let parser = JSONParser.rootParser(json: json, options: options)
        let result = parser.required(ParsedType.self, min: nil, max: nil)
        return ParseResult(value: result, errors: parser.errors)
    }

    private static func rootParser(json: Any?, options: [String: Any]) -> NodeParser {
        let rootNodeName = options[NodeParser.Options.rootNodeNameKey] as? String ?? "root"
        let rootNode = PathNode(hashKey: rootNodeName, swiftType: nil)
        return NodeParser(codingKey: rootNode, json: json, parent: nil, options: options)
    }
}
