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
        let parser = try rootParser(data: data, options: options)
        let result = parser.required(type)
        return (result, parser.errors)
    }

    public static func parse<ParsedType: Parseable>(data: Data, options: JSONSerialization.ReadingOptions = [], to type: [ParsedType].Type) throws -> ([ParsedType]?, [ParseError]) {
        let parser = try rootParser(data: data, options: options)
        let result = parser.required(type, min: nil, max: nil)
        return (result, parser.errors)
    }

    public static func parse<ParsedType: Parseable>(data: Data, options: JSONSerialization.ReadingOptions = [], to type: [String: ParsedType].Type) throws -> ([String: ParsedType]?, [ParseError]) {
        let parser = try rootParser(data: data, options: options)
        let result = parser.required(type, min: nil, max: nil)
        return (result, parser.errors)
    }

    private static func rootParser(data: Data, options: JSONSerialization.ReadingOptions) throws -> NodeParser {
        let json = try JSONSerialization.jsonObject(with: data, options: options)
        let rootNode = PathNode(hashKey: "root", swiftType: nil)
        return NodeParser(node: rootNode, json: json, parent: nil)
    }
}
