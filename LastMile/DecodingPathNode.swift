//
//  DecodingPathNode.swift
//  LastMile
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public struct DecodingPathNode: Equatable {
    public let hashKey: String?
    public let arrayIndex: Int?
    public var castableJSONTypes = Set<JSONElement>()
    public var swiftType: Any.Type?
    public var idKey: String?
    public var id: String?
}


public func ==(lhs: DecodingPathNode, rhs: DecodingPathNode) -> Bool {
    return lhs as CodingKey == rhs as CodingKey
}


public func ==(lhs: CodingKey, rhs: CodingKey) -> Bool {
    return lhs.stringValue == rhs.stringValue && lhs.intValue == rhs.intValue
}


extension DecodingPathNode {

    init(codingKey: CodingKey) {
        let hashKey = codingKey.intValue == nil ? codingKey.stringValue : nil
        self.init(hashKey: hashKey, arrayIndex: codingKey.intValue, castableJSONTypes: [], swiftType: nil, idKey: nil, id: nil)
    }

    init(hashKey: String, swiftType: Decodable.Type?) {
        self.init(hashKey: hashKey, arrayIndex: nil, castableJSONTypes: [], swiftType: swiftType, idKey: nil, id: nil)
    }

    init(arrayIndex: Int, swiftType: Decodable.Type?) {
        self.init(hashKey: nil, arrayIndex: arrayIndex, castableJSONTypes: [], swiftType: swiftType, idKey: nil, id: nil)
    }
}


extension DecodingPathNode: CodingKey {
    public var stringValue: String { return hashKey ?? "\(arrayIndex!)"}
    public var intValue: Int? { return arrayIndex }

    public init?(stringValue: String) {
        self.init(hashKey: stringValue, swiftType: nil)
    }

    public init?(intValue: Int) {
        self.init(arrayIndex: intValue, swiftType: nil)
    }
}


extension DecodingPathNode: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int

    public init(integerLiteral value: DecodingPathNode.IntegerLiteralType) {
        self.init(arrayIndex: value, swiftType: nil)
    }
}


extension DecodingPathNode: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    public init(stringLiteral value: DecodingPathNode.StringLiteralType) {
        self.init(hashKey: value, swiftType: nil)
    }
}


extension Array where Element == DecodingPathNode {

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
