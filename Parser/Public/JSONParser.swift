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

    public static func parse<ParsedType: Parseable>(json: Any, to type: ParsedType.Type) -> (ParsedType?, [ParseError]) {
        let parser = rootParser(json: json)
        let result = parser.required(type, min: nil, max: nil)
        return (result, parser.errors)
    }

    private static func rootParser(json: Any) -> NodeParser {
        let rootNode = PathNode(hashKey: "root", swiftType: nil)
        return NodeParser(codingKey: rootNode, json: json, parent: nil)
    }
}
