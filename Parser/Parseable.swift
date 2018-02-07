//
//  Parseable.swift
//  Parser
//
//  Created by Josh Elkins on 2/7/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public protocol Parseable {
    static var idKey: String? { get }
    init?(parser: Parser)
}


extension Parseable {

    static func id(from json: Any?) -> String? {
        guard let idKey = idKey, let jsonDictionary = json as? [String: Any] else { return nil }
        if let int = jsonDictionary[idKey] as? Int {
            return String(describing: int)
        } else if let string = jsonDictionary[idKey] as? String {
            return string
        }
        return nil
    }
}
