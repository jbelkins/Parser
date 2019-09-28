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

    static func type(`for` node: JSONNode?) -> JSONElement {
        guard let contents = node?.contents else { return .absent }
        switch contents {
        case .object: return .object
        case .array: return .array
        case .string: return .string
        case .number(let nsNumber):
            return Int(exactly: nsNumber) != nil ? .integer : .decimal
        case .bool: return .boolean
        case .null: return .null
        }
    }
}
