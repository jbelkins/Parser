//
//  PathNode.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


struct PathNode {
    let jsonKey: String
    let arrayIndex: Int?
    let dictionaryKey: String?
    let swiftType: Parseable.Type?
    var idKey: String?
    var id: String?
}

extension PathNode {

    init(jsonKey: String, swiftType: Parseable.Type?) {
        self.init(jsonKey: jsonKey, arrayIndex: nil, dictionaryKey: nil, swiftType: swiftType, idKey: nil, id: nil)
    }
}
