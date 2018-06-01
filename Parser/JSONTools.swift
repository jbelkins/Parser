//
//  JSONTools.swift
//  Parser
//
//  Created by Josh Elkins on 2/10/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


struct JSONTools {

    static func traverseJSON(json: Any?, at node: CodingKey) -> Any? {
        if let arrayIndex = node.intValue {
            guard let localJSONArray = json as? [Any] else { return nil }
            guard arrayIndex < localJSONArray.count else { return nil }
            return localJSONArray[arrayIndex]
        } else {
            guard let localJSONDict = json as? [String: Any] else { return nil }
            return localJSONDict[node.stringValue]
        }
    }
}
