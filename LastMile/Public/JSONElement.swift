//
//  JSONElement.swift
//  LastMile
//
//  Created by Josh Elkins on 2/10/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public enum JSONElement: String, Equatable {
    case object = "Object"
    case array = "Array"
    case integer = "Integer"
    case boolean = "Boolean"
    case decimal = "Decimal"
    case string = "String"
    case null = "Null"
    case absent = "no value present"
    case unknown = "Unknown"

    static func type(`for` json: Any?) -> JSONElement {
        guard let json = json else { return .absent }
        if let _ = json as? [String: Any] { return .object }
        if let _ = json as? [Any] { return .array }
        if let nsNumber = json as? NSNumber {
            if nsNumber.isBoolean {
                return .boolean
            } else {
                if let _ = Int(exactly: nsNumber) { return .integer }
                if let _ = Double(exactly: nsNumber) { return .decimal }
            }
        }
        if let _ = json as? String { return .string }
        if let _ = json as? NSNull { return .null }
        return .unknown
    }
}
