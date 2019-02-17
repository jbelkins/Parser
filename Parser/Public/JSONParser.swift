//
//  JSONParser.swift
//  Parser
//
//  Created by Josh Elkins on 2/12/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


import Foundation


open class JSONParser {

    public static func parse<ParsedType: Parseable>(json: Any, to type: ParsedType.Type, options: [String: Any] = [:]) -> (ParsedType?, [ParseError]) {
        let parser = rootParser(json: json, options: options)
        let result = parser.required(type, min: nil, max: nil)
        return (result, parser.errors)
    }

    private static func rootParser(json: Any, options: [String: Any]) -> NodeParser {
        let rootNodeName = options[NodeParser.Options.rootNodeNameKey] as? String ?? "root"
        let rootNode = PathNode(hashKey: rootNodeName, swiftType: nil)
        return NodeParser(codingKey: rootNode, json: json, parent: nil, options: options)
    }
}
