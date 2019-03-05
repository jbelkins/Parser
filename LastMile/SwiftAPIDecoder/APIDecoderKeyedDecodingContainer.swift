//
//  APIDecoderKeyedDecodingContainer.swift
//  LastMile
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


class APIDecoderKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    var codingPath: [CodingKey] { return decoder.codingPath }
    let decoder: APIDecoder

    init(decoder: APIDecoder) {
        self.decoder = decoder
    }

    public var allKeys: [Key] {
        guard let jsonDict = decoder.json as? [String: Any] else { return [] }
        return jsonDict.keys.map { Key.init(stringValue: $0)! }
    }

    public func contains(_ key: Key) -> Bool {
        return allKeys.contains { $0.stringValue == key.stringValue }
    }

    public func decodeNil(forKey key: Key) throws -> Bool {
        return APIDecoderSingleValueDecodingContainer(decoder: decoder[key]).decodeNil()
    }

    public func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Swift.Decodable {
        return try APIDecoderSingleValueDecodingContainer(decoder: decoder[key]).decode(T.self)
    }

    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        let keyed = APIDecoderKeyedDecodingContainer<NestedKey>(decoder: decoder[key])
        return KeyedDecodingContainer(keyed)
    }

    public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        return APIDecoderUnkeyedDecodingContainer(decoder: decoder[key])
    }

    public func superDecoder() throws -> Swift.Decoder {
        return SwiftAPIDecoder(decoder: decoder["super"])
    }

    public func superDecoder(forKey key: Key) throws -> Swift.Decoder {
        return SwiftAPIDecoder(decoder: decoder[key])
    }
}
