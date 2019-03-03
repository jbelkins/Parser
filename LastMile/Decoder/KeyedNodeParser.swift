//
//  NodeParser+KeyedContainer.swift
//  Parser
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


class KeyedNodeParser<Key: CodingKey>: KeyedDecodingContainerProtocol {
    var codingPath: [CodingKey] { return parser.nodePath }
    let parser: Parser

    init(parser: Parser) {
        self.parser = parser
    }

    public var allKeys: [Key] {
        guard let jsonDict = parser.json as? [String: Any] else { return [] }
        return jsonDict.keys.map { Key.init(stringValue: $0)! }
    }

    public func contains(_ key: Key) -> Bool {
        return allKeys.contains { $0.stringValue == key.stringValue }
    }

    public func decodeNil(forKey key: Key) throws -> Bool {
        return SingleValueNodeParser(parser: parser[key]).decodeNil()
    }

    public func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        return try SingleValueNodeParser(parser: parser[key]).decode(T.self)
    }

    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        let keyed = KeyedNodeParser<NestedKey>(parser: self.parser[key])
        return KeyedDecodingContainer(keyed)
    }

    public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        return UnkeyedNodeParser(parser: parser[key])
    }

    public func superDecoder() throws -> Decoder {
        return self.parser
    }

    public func superDecoder(forKey key: Key) throws -> Decoder {
        return self.parser[key]
    }
}
