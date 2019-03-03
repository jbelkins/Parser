//
//  RawRepresentable+Parseable.swift
//  LastMile
//
//  Created by Josh Elkins on 2/28/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation


extension RawRepresentable where RawValue: Parseable {

    public init?(parser: Parser) {
        guard let rawValue = parser --> RawValue.self else { return nil }
        guard let value = Self.init(rawValue: rawValue) else {
            let error = ParseError(path: parser.nodePath, rawValue: "\(rawValue)", type: "\(Self.self)")
            parser.recordError(error)
            return nil
        }
        self = value
    }
}
