//
//  DecodingPathNode.swift
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


public struct APICodingKey: Equatable {
    public let hashKey: String?
    public let arrayIndex: Int?
    public var jsonType: JSONElement
    public var swiftType: Any.Type?
    public var idKey: String?
    public var id: String?
}


public func ==(lhs: APICodingKey, rhs: APICodingKey) -> Bool {
    return lhs as CodingKey == rhs as CodingKey
}


public func ==(lhs: CodingKey, rhs: CodingKey) -> Bool {
    return lhs.stringValue == rhs.stringValue && lhs.intValue == rhs.intValue
}


extension APICodingKey {

    init(codingKey: CodingKey) {
        let hashKey = codingKey.intValue == nil ? codingKey.stringValue : nil
        self.init(hashKey: hashKey, arrayIndex: codingKey.intValue, jsonType: .unknown, swiftType: nil, idKey: nil, id: nil)
    }

    init(hashKey: String, swiftType: Decodable.Type?) {
        self.init(hashKey: hashKey, arrayIndex: nil, jsonType: .unknown, swiftType: swiftType, idKey: nil, id: nil)
    }

    init(arrayIndex: Int, swiftType: Decodable.Type?) {
        self.init(hashKey: nil, arrayIndex: arrayIndex, jsonType: .unknown, swiftType: swiftType, idKey: nil, id: nil)
    }
}


extension APICodingKey: CodingKey {
    public var stringValue: String { return hashKey ?? "\(arrayIndex!)"}
    public var intValue: Int? { return arrayIndex }

    public init?(stringValue: String) {
        self.init(hashKey: stringValue, swiftType: nil)
    }

    public init?(intValue: Int) {
        self.init(arrayIndex: intValue, swiftType: nil)
    }
}


extension APICodingKey: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int

    public init(integerLiteral value: APICodingKey.IntegerLiteralType) {
        self.init(arrayIndex: value, swiftType: nil)
    }
}


extension APICodingKey: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    public init(stringLiteral value: APICodingKey.StringLiteralType) {
        self.init(hashKey: value, swiftType: nil)
    }
}


extension Array where Element == APICodingKey {

    public var jsonPath: String {
        guard let firstNode = self.first else { return "" }
        var string = firstNode.hashKey ?? "root"
        let theRest = self[1...]
        for node in theRest {
            if let key = node.hashKey {
                string += "[\"\(key)\"]"
            } else if let index = node.arrayIndex {
                string += "[\(index)]"
            }
        }
        return string
    }

    public var taggedJSONPath: String {
        return self.map { node in
            var string = ""
            if let key = node.hashKey {
                string += (node == self.first) ? "\(key)" : "\"\(key)\""
            } else if let index = node.arrayIndex {
                string += "[\(index)]"
            }
            if let type = node.swiftType {
                var idString = ""
                if let parseableType = type as? APIDecodable.Type, let idKey = parseableType.idKey, let id = node.id {
                    idString += " \(idKey)=\(id)"
                }
                string += "(\(type)\(idString))"
            }
            return string
        }.joined(separator: " > ")
    }
}
