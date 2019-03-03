//
//  UnkeyedNodeParser.swift
//  LastMile
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


class UnkeyedNodeParser: UnkeyedDecodingContainer {
    var codingPath: [CodingKey] { return parser.nodePath }
    let parser: Parser
    var currentIndex: Int = -1

    init(parser: Parser) {
        self.parser = parser
    }

    public func superDecoder() throws -> Decoder {
        return parser["super"]
    }

    public var count: Int? {
        return (parser.json as? [Any])?.count
    }

    public var isAtEnd: Bool {
        return currentIndex == (count ?? 0) - 1
    }

    public func decodeNil() -> Bool {
        return SingleValueNodeParser(parser: parser[nextCodingKey()]).decodeNil()
    }

    public func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        return try T.init(from: parser[nextCodingKey()])
    }

    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        let keyed = KeyedNodeParser<NestedKey>(parser: parser[nextCodingKey()])
        return KeyedDecodingContainer(keyed)
    }

    public func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        return UnkeyedNodeParser(parser: parser[nextCodingKey()])
    }

    private func nextCodingKey() -> CodingKey {
        currentIndex += 1
        return PathNode(intValue: currentIndex)!
    }
}
