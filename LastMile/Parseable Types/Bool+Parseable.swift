//
//  Bool+Parseable.swift
//  LastMile
//
//  Created by Josh Elkins on 2/11/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension Bool: Parseable {
    
    public init?(parser: Parser) {
        guard let nsNumber = parser.json as? NSNumber, nsNumber.isBoolean else {
            let error = ParseError(path: parser.nodePath, actual: parser.node.castableJSONTypes)
            parser.recordError(error)
            return nil
        }
        self = nsNumber.boolValue
    }
}


extension NSNumber {
    var isBoolean: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
