//
//  ResponseData.swift
//  Parser
//
//  Created by Josh Elkins on 3/1/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation


public struct ResponseData: Parseable {
    public let data: Data?

    public init?(parser: Parser) {
        let data = parser.options[ParserOptions.rawDataKey] as? Data
        self.data = data
    }
}
