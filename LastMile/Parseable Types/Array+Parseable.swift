//
//  Array+Parseable.swift
//  LastMile
//
//  Created by Josh Elkins on 5/29/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation

extension Array: Parseable where Element: Parseable {
    public var parseableElementCount: Int? { return count }

    public init?(parser: Parser) {
        guard let jsonArray = parser.json as? [Any] else {
            let error = ParseError(path: parser.nodePath, actual: parser.node.castableJSONTypes)
            parser.recordError(error)
            return nil
        }
        let uncompactedArray = jsonArray.indices.map { parser[$0] --> Element.self }
        self = uncompactedArray.compactMap { $0 }
    }
}
