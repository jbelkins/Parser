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
    var parseableElementCount: Int? { get }

    init?(parser: Parser)
}


extension Parseable {
    public static var idKey: String? { return nil }
    public var parseableElementCount: Int? { return nil }

    static func id(from json: Any?) -> String? {
        guard let idKey = idKey, let jsonDictionary = json as? [String: Any] else { return nil }
        if let id: CustomStringConvertible = jsonDictionary[idKey] as? Int ?? jsonDictionary[idKey] as? String {
            return String(describing: id)
        }
        return nil
    }
}
