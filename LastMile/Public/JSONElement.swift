//
//  JSONElement.swift
//  LastMile
//
//  Copyright (c) 2018 Josh Elkins
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
