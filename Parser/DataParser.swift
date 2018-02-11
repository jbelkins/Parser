//
//  DataParser.swift
//  Parser
//
//  Created by Josh Elkins on 2/7/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


open class DataParser {

    public static func parse<ParsedType: Parseable>(data: Data, options: JSONSerialization.ReadingOptions = [], to type: ParsedType.Type) throws -> (ParsedType?, [ParseError]) {
        let json = try JSONSerialization.jsonObject(with: data, options: options)
        let rootNode = PathNode(hashKey: "root", swiftType: nil)
        let parser = NodeParser(node: rootNode, json: json, parent: nil)
        let result = parser.required(type)
        return (result, parser.errors)
    }
}
