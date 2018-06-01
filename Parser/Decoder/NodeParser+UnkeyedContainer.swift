//
//  NodeParser+UnkeyedContainer.swift
//  Parser
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension NodeParser: UnkeyedDecodingContainer {
    public func superDecoder() throws -> Decoder {
        return self
    }


    public var count: Int? {
        guard let jsonArray = json as? [Any] else { return nil }
        return jsonArray.count
    }

    public var isAtEnd: Bool {
        return currentIndex >= count ?? 0
    }

    public func decodeNil() -> Bool {
        if isUnkeyedContainer {
            return self[nextCodingKey()].decodeNil()
        } else {
            guard let something = json else { return true }
            return something is NSNull
        }
    }


    public func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        if isUnkeyedContainer {
            return try T.init(from: self[nextCodingKey()])
        } else {
            return try T.init(from: self)
        }
    }

    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        let keyed = KeyedNodeParser<NestedKey>(parser: self[nextCodingKey()])
        return KeyedDecodingContainer(keyed)
    }

    public func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        let newParser = self[nextCodingKey()]
        newParser.isUnkeyedContainer = true
        return newParser
    }

    private func nextCodingKey() -> CodingKey {
        currentIndex += 1
        return PathNode(intValue: currentIndex)!
    }
}
