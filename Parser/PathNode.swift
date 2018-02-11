//
//  PathNode.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public struct PathNode {
    public let hashKey: String?
    public let arrayIndex: Int?
    public var jsonType: JSONElement
    public var swiftType: Any.Type?
    public var idKey: String?
    public var id: String?
}

extension PathNode {

    init(hashKey: String, swiftType: Parseable.Type?) {
        self.init(hashKey: hashKey, arrayIndex: nil, jsonType: .absent, swiftType: swiftType, idKey: nil, id: nil)
    }

    init(arrayIndex: Int, swiftType: Parseable.Type?) {
        self.init(hashKey: nil, arrayIndex: arrayIndex, jsonType: .absent, swiftType: swiftType, idKey: nil, id: nil)
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
