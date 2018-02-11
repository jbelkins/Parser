//
//  Int+Parseable.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension Int: Parseable, JSONRawValueType {
    public static var idKey: String? = nil
    public static let jsonType: JSONElement = .int
}
