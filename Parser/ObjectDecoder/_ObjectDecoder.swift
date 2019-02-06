//
//  _ObjectDecoder.swift
//  Parser
//
//  Created by Josh Elkins on 3/1/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


class _ObjectDecoder: Decoder {
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
        let objectKeyedContainer = try ObjectKeyedContainer<Key>(codingPath: codingPath, jsonObject: jsonObject)
        return KeyedDecodingContainer(objectKeyedContainer)
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return try ObjectUnkeyedContainer(codingPath: codingPath, jsonObject: jsonObject)
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return ObjectSingleValueContainer(codingPath: codingPath, jsonObject: jsonObject)
    }
}
