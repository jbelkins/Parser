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
    public let swiftType: Parseable.Type?
    public var idKey: String?
    public var id: String?
}

extension PathNode {

    init(hashKey: String, swiftType: Parseable.Type?) {
        self.init(hashKey: hashKey, arrayIndex: nil, swiftType: swiftType, idKey: nil, id: nil)
    }

    init(arrayIndex: Int, swiftType: Parseable.Type?) {
        self.init(hashKey: nil, arrayIndex: arrayIndex, swiftType: swiftType, idKey: nil, id: nil)
    }
}
