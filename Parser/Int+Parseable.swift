//
//  Int+Parseable.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension Int: Parseable {
    static var idKey: String? = nil

    init?(parser: inout Parser) {
        guard let int = parser.json as? Int else { return nil }
        self = int
    }
}
