//
//  JSONParser.swift
//  LastMile
//
//  Created by Josh Elkins on 2/12/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public class JSONParser {

    public init() {}

    public func parse<DecodedType: APIDecodable>(json: Any?, to type: DecodedType.Type, options: [String: Any] = [:]) -> DecodeResult<DecodedType> {
        let parser = JSONParser.rootParser(json: json, options: options)
        let result = parser.required(DecodedType.self, min: nil, max: nil)
        return DecodeResult(value: result, errors: parser.errors)
    }

    private static func rootParser(json: Any?, options: [String: Any]) -> NodeParser {
        let rootNodeName = options[ParserOptions.rootNodeNameKey] as? String ?? "root"
        let rootNode = PathNode(hashKey: rootNodeName, swiftType: nil)
        return NodeParser(codingKey: rootNode, json: json, parent: nil, options: options)
    }
}
