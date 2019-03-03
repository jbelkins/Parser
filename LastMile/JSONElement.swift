//
//  JSONElement.swift
//  LastMile
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

    static func types(`for` json: Any?) -> Set<JSONElement> {
        var types = Set<JSONElement>()
        if let _ = json as? [String: Any] { types.insert(.object) }
        if let _ = json as? [Any] { types.insert(.array) }
        if let nsNumber = json as? NSNumber {
            if nsNumber.isBoolean {
                types.insert(.bool)
            } else {
                if let _ = Int(exactly: nsNumber) { types.insert(.int) }
                if let _ = Double(exactly: nsNumber) { types.insert(.double) }
            }
        }
        if let _ = json as? String { types.insert(.string) }
        if let _ = json as? NSNull { types.insert(.null) }
        return types.isEmpty ? [.absent] : types
    }
}
