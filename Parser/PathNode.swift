//
//  PathNode.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public struct PathNode: Equatable {
    public let hashKey: String?
    public let arrayIndex: Int?
    public var expectedJSONType: JSONElement
    public var castableJSONTypes = [JSONElement]()
    public var swiftType: Any.Type?
    public var idKey: String?
    public var id: String?
}


public func ==(lhs: PathNode, rhs: PathNode) -> Bool {
    return lhs as CodingKey == rhs as CodingKey
}


public func ==(lhs: CodingKey, rhs: CodingKey) -> Bool {
    return lhs.stringValue == rhs.stringValue && lhs.intValue == rhs.intValue
}


extension PathNode {

    init(codingKey: CodingKey) {
        let hashKey = codingKey.intValue == nil ? codingKey.stringValue : nil
        self.init(hashKey: hashKey, arrayIndex: codingKey.intValue, expectedJSONType: .absent, castableJSONTypes: [], swiftType: nil, idKey: nil, id: nil)
    }

    init(hashKey: String, swiftType: Parseable.Type?) {
        self.init(hashKey: hashKey, arrayIndex: nil, expectedJSONType: .absent, castableJSONTypes: [], swiftType: swiftType, idKey: nil, id: nil)
    }

    init(arrayIndex: Int, swiftType: Parseable.Type?) {
        self.init(hashKey: nil, arrayIndex: arrayIndex, expectedJSONType: .absent, castableJSONTypes: [], swiftType: swiftType, idKey: nil, id: nil)
    }
}


extension PathNode: CodingKey {
    public var stringValue: String { return hashKey ?? "\(arrayIndex!)"}
    public var intValue: Int? { return arrayIndex }

    public init?(stringValue: String) {
        self.init(hashKey: stringValue, swiftType: nil)
    }

    public init?(intValue: Int) {
        self.init(arrayIndex: intValue, swiftType: nil)
    }
}


extension Array where Element == PathNode {

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
}
