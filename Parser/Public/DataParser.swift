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
        return JSONParser.parse(json: json, to: type)
    }

    public static func parse<ParsedType: Parseable>(data: Data, options: JSONSerialization.ReadingOptions = [], to type: [String: ParsedType].Type) throws -> ([String: ParsedType]?, [ParseError]) {
        let json = try JSONSerialization.jsonObject(with: data, options: options)
        return JSONParser.parse(json: json, to: type)
    }
}
