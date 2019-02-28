//
//  DataParser.swift
//  Parser
//
//  Created by Josh Elkins on 2/7/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


open class DataParser {

    public init() {}

    public func parse<ParsedType: Parseable>(data: Data, to type: ParsedType.Type, options: [String: Any] = [:]) throws -> ParseResult<ParsedType> {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSONParser().parse(json: json, to: ParsedType.self, options: options)
    }
}
