//
//  ObjectUnkeyedContainer.swift
//  Parser
//
//  Created by Josh Elkins on 5/28/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


struct UnkeyedCodingKey: CodingKey {
    var stringValue: String {
        return "\(intValue!)"
    }

    var intValue: Int?

    init?(intValue: Int) {
        self.intValue = intValue
    }

    init?(stringValue: String) {
        return nil
    }
}


class ObjectUnkeyedContainer: UnkeyedDecodingContainer {
    let jsonArray: [Any]
    let codingPath: [CodingKey]

    var count: Int? { return jsonArray.count }

    var isAtEnd: Bool { return currentIndex >= jsonArray.count - 1 }

    var currentIndex: Int = -1

    init(codingPath: [CodingKey], jsonArray: [Any]) {
        self.codingPath = codingPath
        self.jsonArray = jsonArray
    }

    func nextCodingPath() -> [CodingKey] {
        currentIndex += 1
        return codingPath + [UnkeyedCodingKey(intValue: currentIndex)!]
    }

    func decodeNil() throws -> Bool {
        return ObjectSingleValueContainer(codingPath: nextCodingPath(), jsonObject: jsonArray[currentIndex]).decodeNil()
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        return try ObjectSingleValueContainer(codingPath: nextCodingPath(), jsonObject: jsonArray[currentIndex]).decode(T.self)
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        let nextCodingPath = self.nextCodingPath()
        guard let nestedJSONDict = jsonArray[currentIndex] as? [String: Any] else {
            throw NodeError.error("Creating keyed container for non-dict")
        }
        let objectKeyedContainer = ObjectKeyedContainer<NestedKey>(codingPath: nextCodingPath, jsonDict: nestedJSONDict)
        return KeyedDecodingContainer(objectKeyedContainer)
    }

    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        let nextCodingPath = self.nextCodingPath()
        guard let nestedJSONArray = jsonArray[currentIndex] as? [Any] else {
            throw NodeError.error("Creating unkeyed container for non-array")
        }
        return ObjectUnkeyedContainer(codingPath: nextCodingPath, jsonArray: nestedJSONArray)
    }

    func superDecoder() throws -> Decoder {
        return ObjectDecoder(codingPath: codingPath, jsonObject: jsonArray)
    }
}
