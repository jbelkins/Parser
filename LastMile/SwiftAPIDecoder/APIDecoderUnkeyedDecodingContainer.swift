//
//  APIDecoderUnkeyedDecodingContainer.swift
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
