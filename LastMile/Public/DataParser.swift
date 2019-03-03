//
//  DataParser.swift
//  Parser
//
//  Created by Josh Elkins on 2/7/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public class DataParser {

    public init() {}

    public func parse<ParsedType: Parseable>(data: Data?, to type: ParsedType.Type, options: [String: Any] = [:]) -> ParseResult<ParsedType> {
        let newData = data ?? Data()
        var newOptions = options
        newOptions[ParserOptions.rawDataKey] = newData
        let json: Any? = try? JSONSerialization.jsonObject(with: newData, options: [])
        return JSONParser().parse(json: json, to: ParsedType.self, options: newOptions)
    }
}
