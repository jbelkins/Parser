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

public enum JSONContents: Equatable {
    case object([String: JSONNode])
    case array([JSONNode])
    case number(NSNumber)
    case string(String)
    case bool(Bool)
    case null

    public static func ==(lhs: JSONContents, rhs: JSONContents) -> Bool {
        switch (lhs, rhs) {
        case (.object(let lhs), .object(let rhs)): return lhs == rhs
        case (.array(let lhs), .array(let rhs)): return lhs == rhs
        case (.number(let lhs), .number(let rhs)): return lhs == rhs
        case (.string(let lhs), .string(let rhs)): return lhs == rhs
        case (.bool(let lhs), .bool(let rhs)): return lhs == rhs
        case(.null, .null): return true
        default: return false
        }
    }
}

public class JSONNode: Equatable {
    let contents: JSONContents

    init(contents: JSONContents) {
        self.contents = contents
    }

    public static func ==(lhs: JSONNode, rhs: JSONNode) -> Bool {
        return lhs.contents == rhs.contents
    }

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
            fatalError("object passed in is not a JSON object")
        }
    }
}
