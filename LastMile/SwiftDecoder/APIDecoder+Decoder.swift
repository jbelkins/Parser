//
//  APIDecoder+Decoder.swift
//  LastMile
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


class NodeParserDecoder: Decoder {
    let decoder: APIDecoder
    var codingPath: [CodingKey] { return decoder.nodePath }
    var userInfo: [CodingUserInfoKey : Any] { return [:] }

    init(decoder: APIDecoder) {
        self.decoder = decoder
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let keyed = APIDecoderKeyedDecodingContainer<Key>(decoder: decoder)
        return KeyedDecodingContainer(keyed)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return APIDecoderUnkeyedDecodingContainer(decoder: decoder)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return APIDecoderSingleValueDecodingContainer(decoder: decoder)
    }

    
}
