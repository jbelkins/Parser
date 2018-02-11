//
//  JSONTools.swift
//  Parser
//
//  Created by Josh Elkins on 2/10/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


struct JSONTools {

    static func traverseJSON(json: Any?, at node: PathNode) -> Any? {
        var localJSON = json
        if let hashKey = node.hashKey {
            guard let localJSONDict = localJSON as? [String: Any] else { return nil }
            localJSON = localJSONDict[hashKey]
        } else if let arrayIndex = node.arrayIndex {
            guard let localJSONArray = localJSON as? [Any] else { return nil }
            guard arrayIndex < localJSONArray.count else { return nil }
            localJSON = localJSONArray[arrayIndex]
        }
        return localJSON
    }
}
