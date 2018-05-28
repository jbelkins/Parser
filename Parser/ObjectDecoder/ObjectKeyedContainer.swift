//
//  ObjectKeyedContainer.swift
//  Parser
//
//  Created by Josh Elkins on 3/1/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


class ObjectKeyedContainer<K>: KeyedDecodingContainerProtocol where K: CodingKey {
    let jsonDict: [String: Any]
    let codingPath: [CodingKey]
    var allKeys: [K] {
        return jsonDict.keys.map { K.init(stringValue: $0)! }
    }

    init(codingPath: [CodingKey], jsonDict: [String: Any]) {
        self.codingPath = codingPath
        self.jsonDict = jsonDict
    }

    func contains(_ key: K) -> Bool {
        return allKeys.index { $0.stringValue == key.stringValue } != nil
    }

    func decodeNil(forKey key: K) throws -> Bool {
        return ObjectSingleValueContainer(codingPath: codingPath + [key], jsonObject: jsonDict[key.stringValue]).decodeNil()
    }

    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
        return try ObjectSingleValueContainer(codingPath: codingPath + [key], jsonObject: jsonDict[key.stringValue]).decode(T.self)
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        guard let nestedJSONDict = jsonDict[key.stringValue] as? [String: Any] else {
            throw NodeError.error("Creating keyed container for non-dict")
        }
        let objectKeyedContainer = ObjectKeyedContainer<NestedKey>(codingPath: codingPath + [key], jsonDict: nestedJSONDict)
        return KeyedDecodingContainer(objectKeyedContainer)
    }

    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
        guard let nestedJSONArray = jsonDict[key.stringValue] as? [Any] else {
            throw NodeError.error("Creating unkeyed container for non-array")
        }
        return ObjectUnkeyedContainer(codingPath: codingPath + [key], jsonArray: nestedJSONArray)
    }

    func superDecoder() throws -> Decoder {
        return ObjectDecoder(codingPath: codingPath, jsonObject: jsonDict)
    }

    func superDecoder(forKey key: K) throws -> Decoder {
        return ObjectDecoder(codingPath: codingPath + [key], jsonObject: jsonDict[key.stringValue]!)
    }
}
