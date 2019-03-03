//
//  ResponseData.swift
//  LastMile
//
//  Created by Josh Elkins on 3/1/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation


public struct ResponseData: Parseable {
    public let data: Data?

    public init?(parser: Parser) {
        self.data = parser.options[ParserOptions.rawDataKey] as? Data
    }
}
