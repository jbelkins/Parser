//
//  Array+Parseable.swift
//  Parser
//
//  Created by Josh Elkins on 5/29/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation

extension Array: Parseable where Element: Parseable {
    public static var idKey: String? { return nil }
    public static var jsonType: JSONElement { return JSONElement.array }

    var parseableElementCount: Int? { return count }

    public init?(parser: Parser) {
        guard let jsonArray = parser.json as? [Any] else {
            let message = "Not an Array, casts to \(parser.node.castableJSONTypes.map { $0.rawValue }.joined(separator: ", "))"
            parser.recordError(ParseError(path: parser.path, message: message))
            return nil
        }
        let uncompactedArray = jsonArray.indices.map { parser[$0].required(Element.self) }
        self = uncompactedArray.filter { $0 != nil }.map { $0! }
    }
}
