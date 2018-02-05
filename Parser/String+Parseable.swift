//
//  String+Parseable.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension String: Parseable {
    static var idKey: String? = nil

    init?(parser: inout Parser) {
        guard let string = parser.json as? String else { return nil }
        self = string
    }
}
