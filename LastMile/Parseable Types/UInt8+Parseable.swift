//
//  UInt8+Parseable.swift
//  LastMile
//
//  Created by Josh Elkins on 3/2/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation


extension UInt8: Parseable {

    public init?(parser: Parser) {
        guard let nsNumber = parser.json as? NSNumber, let uint8 = UInt8(exactly: nsNumber) else {
            let error = ParseError(path: parser.nodePath, actual: parser.node.castableJSONTypes)
            parser.recordError(error)
            return nil
        }
        self = uint8
    }
}
