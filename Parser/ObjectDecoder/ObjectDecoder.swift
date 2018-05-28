//
//  ObjectDecoder.swift
//  Parser
//
//  Created by Josh Elkins on 3/1/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public enum NodeError: Error {
    case error(String)

    var localizedDescription: String {
        switch self {
        case .error(let message): return message
        }
    }
}


public class ObjectDecoder: Decoder {
    public let jsonObject: Any?
    public let codingPath: [CodingKey]
    public var userInfo: [CodingUserInfoKey : Any] = [:]

    public init(jsonObject: Any) {
        self.codingPath = []
        self.jsonObject = jsonObject
    }

    init(codingPath: [CodingKey], jsonObject: Any?) {
        self.codingPath = codingPath
        self.jsonObject = jsonObject
    }

    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        guard let nestedJSONDict = jsonObject as? [String: Any] else {
            throw NodeError.error("Creating keyed container for non-dict")
        }
        let objectKeyedContainer = ObjectKeyedContainer<Key>(codingPath: codingPath, jsonDict: nestedJSONDict)
        return KeyedDecodingContainer(objectKeyedContainer)
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard let jsonArray = jsonObject as? [Any] else {
            throw NodeError.error("Creating unkeyed container for non-array")
        }
        return ObjectUnkeyedContainer(codingPath: codingPath, jsonArray: jsonArray)
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return ObjectSingleValueContainer(codingPath: codingPath, jsonObject: jsonObject)
    }
}
