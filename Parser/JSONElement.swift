//
//  JSONElement.swift
//  Parser
//
//  Created by Josh Elkins on 2/10/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public enum JSONElement: String {
    case object = "[String: Any]"
    case array = "[Any]"
    case int = "Int"
    case bool = "Bool"
    case double = "Double"
    case string = "String"
    case null = "NSNull"
    case absent = "absent"

    init(json: Any?) {
        switch json {
        case is [String: Any]: self = .object
        case is [Any]: self = .array
        case is Bool: self = .bool
        case is Int: self = .int
        case is Double: self = .double
        case is String: self = .string
        case is NSNull: self = .null
        default: self = .absent
        }
    }
}
