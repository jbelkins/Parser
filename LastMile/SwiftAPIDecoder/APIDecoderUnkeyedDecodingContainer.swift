//
//  APIDecoderUnkeyedDecodingContainer.swift
//  LastMile
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


class APIDecoderUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    var codingPath: [CodingKey] { return decoder.codingPath }
    let decoder: APIDecoder
    var currentIndex: Int = -1

    init(decoder: APIDecoder) {
        self.decoder = decoder
    }

    func superDecoder() throws -> Swift.Decoder {
        return SwiftAPIDecoder(decoder: decoder)
    }

    var count: Int? {
        return (decoder.json as? [Any])?.count
    }

    var isAtEnd: Bool {
        return currentIndex == (count ?? 0) - 1
    }

    func decodeNil() -> Bool {
        return APIDecoderSingleValueDecodingContainer(decoder: decoder[nextCodingKey()]).decodeNil()
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Swift.Decodable {
        return try APIDecoderSingleValueDecodingContainer(decoder: decoder[nextCodingKey()]).decode(T.self)
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        let keyed = APIDecoderKeyedDecodingContainer<NestedKey>(decoder: decoder[nextCodingKey()])
        return KeyedDecodingContainer(keyed)
    }

    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        return APIDecoderUnkeyedDecodingContainer(decoder: decoder[nextCodingKey()])
    }

    func nextCodingKey() -> CodingKey {
        currentIndex += 1
        return APICodingKey(intValue: currentIndex)!
    }
}
