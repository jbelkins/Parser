//
//  JSONNode.swift
//  LastMile
//
//  Copyright (c) 2019 Josh Elkins
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
//

import Foundation


public class JSONNode {
    let contents: JSONContents

    init(contents: JSONContents) {
        self.contents = contents
    }
}


extension JSONNode {

    static func tree(from json: Any?) -> JSONNode? {
        guard let json = json else { return nil }
        return node(from: json)
    }

    private static func node(from json: Any) -> JSONNode {
        if let dict = json as? [String: Any] {
            return JSONNode(contents: .object(dict.mapValues { JSONNode.node(from: $0) } ))
        } else if let array = json as? [Any] {
            return JSONNode(contents: .array(array.map { JSONNode.node(from: $0) } ))
        } else if let number = json as? NSNumber {
            if number.isBoolean {
                return JSONNode(contents: .bool(number.boolValue))
            } else {
                return JSONNode(contents: .number(number))
            }
        } else if let string = json as? String {
            return JSONNode(contents: .string(string))
        } else if json is NSNull {
            return JSONNode(contents: .null)
        } else {
            return JSONNode(contents: .unknown(json))
        }
    }
}


extension JSONNode {

    subscript(key: CodingKey) -> JSONNode? {
        if let index = key.intValue {
            guard case .array(let array) = contents else { return nil }
            guard index < array.count else { return nil }
            return array[index]
        } else {
            guard case .object(let dict) = contents else { return nil }
            return dict[key.stringValue]
        }
    }
}


extension JSONNode {

    var type: JSONElement {
        switch self.contents {
        case .object: return .object
        case .array: return .array
        case .string: return .string
        case .number(let nsNumber):
            return Int(exactly: nsNumber) != nil ? .integer : .decimal
        case .bool: return .boolean
        case .null: return .null
        case .unknown: return .unknown
        }
    }
}


extension JSONNode: Equatable {

    public static func ==(lhs: JSONNode, rhs: JSONNode) -> Bool {
        return lhs.contents == rhs.contents
    }
}
