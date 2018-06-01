//
//  NodeParser+Decoder.swift
//  Parser
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension NodeParser: Decoder {
    public var codingPath: [Key] {
        return path as! [Key]
    }

    public var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(self)
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return self
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }

    
}
