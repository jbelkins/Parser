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
        let json: Any?
        do {
            json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
        } catch let error as NSError where error.code == 3840 && error.domain == NSCocoaErrorDomain {
            json = nil
        }
        return JSONParser().parse(json: json, to: ParsedType.self, options: options)
    }
}
