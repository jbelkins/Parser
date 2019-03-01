//
//  RawRepresentable+Parseable.swift
//  Parser
//
//  Created by Josh Elkins on 2/28/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation


extension RawRepresentable where RawValue: Parseable {

    public init?(parser: Parser) {
        guard let rawValue = parser --> RawValue.self else { return nil }
        guard let value = Self.init(rawValue: rawValue) else {
            let message = "Raw value of \"\(rawValue)\" for type \(Self.self) not defined"
            parser.recordError(ParseError(path: parser.nodePath, message: message))
            return nil
        }
        self = value
    }
}
