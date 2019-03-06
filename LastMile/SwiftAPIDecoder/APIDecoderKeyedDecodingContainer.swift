//
//  APIDecoderKeyedDecodingContainer.swift
//  LastMile
//
//  Copyright (c) 2018 Josh Elkins
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
