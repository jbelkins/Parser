//
//  JSONElement.swift
//  Parser
//
//  Created by Josh Elkins on 2/10/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public enum JSONElement: String, Equatable {
    case object = "[String: Any]"
    case array = "[Any]"
    case int = "Int"
    case bool = "Bool"
    case double = "Double"
    case string = "String"
    case null = "NSNull"
    case absent = "absent"

    static func types(`for` json: Any?) -> [JSONElement] {
        var types = [JSONElement]()
        if let _ = json as? [String: Any] { types.append(.object) }
        if let _ = json as? [Any] { types.append(.array) }
        if let _ = json as? Int { types.append(.int) }
        if let _ = json as? Bool { types.append(.bool) }
        if let _ = json as? Double { types.append(.double) }
        if let _ = json as? String { types.append(.string) }
        if let _ = json as? NSNull { types.append(.null) }
        return types.isEmpty ? [.absent] : types
    }
}
