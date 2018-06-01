//
//  NodeParser+KeyedContainer.swift
//  Parser
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension NodeParser: KeyedDecodingContainerProtocol {

    public var allKeys: [PathNode] {
        guard let jsonDict = json as? [String: Any] else { return [] }
        return jsonDict.keys.map { PathNode(hashKey: $0, swiftType: nil) }
    }

    public func contains(_ key: PathNode) -> Bool {
        return allKeys.contains(key)
    }

    public func decodeNil(forKey key: PathNode) throws -> Bool {
        return self[key].decodeNil()
    }

    public func decode<T>(_ type: T.Type, forKey key: PathNode) throws -> T where T : Decodable {
        return self[key].decode(T.self)
    }

    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: PathNode) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        guard let jsonDict = json as? [String: Any], let nestedKey = NestedKey(stringValue: key.stringValue) else {
            throw NodeError.error("Could not create nested container")
        }
        let newParser = NodeParser(node: nestedKey, json: jsonDict[key.stringValue], parent: self)
        return KeyedDecodingContainer(newParser)
    }

    public func nestedUnkeyedContainer(forKey key: PathNode) throws -> UnkeyedDecodingContainer {
        return self[key]
    }

    public func superDecoder() throws -> Decoder {
        return self
    }

    public func superDecoder(forKey key: PathNode) throws -> Decoder {
        return self[key]
    }
}
