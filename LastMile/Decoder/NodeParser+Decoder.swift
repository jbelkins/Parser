//
//  NodeParser+Decoder.swift
//  LastMile
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension NodeParser: Decoder {
    public var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let keyed = KeyedNodeParser<Key>(parser: self)
        return KeyedDecodingContainer(keyed)
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return UnkeyedNodeParser(parser: self)
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return SingleValueNodeParser(parser: self)
    }

    
}
