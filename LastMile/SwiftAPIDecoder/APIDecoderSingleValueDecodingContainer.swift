//
//  APIDecoderSingleValueDecodingContainer.swift
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


class APIDecoderSingleValueDecodingContainer: SingleValueDecodingContainer {
    var codingPath: [CodingKey] { return decoder.codingPath }
    let decoder: APIDecoder

    init(decoder: APIDecoder) {
        self.decoder = decoder
    }

    func decodeNil() -> Bool {
        return decoder.json is NSNull
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        let swiftDecoder = SwiftAPIDecoder(decoder: decoder)
        return try T.init(from: swiftDecoder)
    }

    public func decode(_ type: Bool.Type) throws -> Bool {
        return try decodeAndReturnOrThrow(Bool.self)
    }

    public func decode(_ type: String.Type) throws -> String {
        return try decodeAndReturnOrThrow(String.self)
    }

    public func decode(_ type: Double.Type) throws -> Double {
        return try decodeAndReturnOrThrow(Double.self)
    }

    public func decode(_ type: Float.Type) throws -> Float {
        return try decodeAndReturnOrThrow(Float.self)
    }

    public func decode(_ type: Int.Type) throws -> Int {
        return try decodeAndReturnOrThrow(Int.self)
    }

    public func decode(_ type: Int8.Type) throws -> Int8 {
        return try decodeAndReturnOrThrow(Int8.self)
    }

    public func decode(_ type: Int16.Type) throws -> Int16 {
        return try decodeAndReturnOrThrow(Int16.self)
    }

    public func decode(_ type: Int32.Type) throws -> Int32 {
        return try decodeAndReturnOrThrow(Int32.self)
    }

    public func decode(_ type: Int64.Type) throws -> Int64 {
        return try decodeAndReturnOrThrow(Int64.self)
    }

    public func decode(_ type: UInt.Type) throws -> UInt {
        return try decodeAndReturnOrThrow(UInt.self)
    }

    public func decode(_ type: UInt8.Type) throws -> UInt8 {
        return try decodeAndReturnOrThrow(UInt8.self)
    }

    public func decode(_ type: UInt16.Type) throws -> UInt16 {
        return try decodeAndReturnOrThrow(UInt16.self)
    }

    public func decode(_ type: UInt32.Type) throws -> UInt32 {
        return try decodeAndReturnOrThrow(UInt32.self)
    }

    public func decode(_ type: UInt64.Type) throws -> UInt64 {
        return try decodeAndReturnOrThrow(UInt64.self)
    }

    private func decodeAndReturnOrThrow<DecodedType: APIDecodable>(_ type: DecodedType.Type) throws -> DecodedType {
        let isolatedDecoder = decoder.errorHoldingDecoder()
        guard let value = isolatedDecoder.decodeRequired(DecodedType.self) else {
            try throwError(decoder: isolatedDecoder, type: DecodedType.self)
        }
        return value
    }

    private func throwError<FailedType>(decoder: APIDecoder, type: FailedType.Type) throws -> Never {
        guard let error = decoder.errors.first, decoder.errors.count == 1 else {
            throw APIDecodeError(path: decoder.path, message: "\(FailedType.self) decoder failed without exactly one error (actually had \(decoder.errors.count))")
        }
        switch error.reason {
        case .lossOfPrecision:
            throw DecodingError.dataCorruptedError(in: self, debugDescription: error.localizedDescription)
        case .unexpectedJSONType:
            let context = DecodingError.Context.init(codingPath: error.codingPath, debugDescription: error.localizedDescription)
            throw DecodingError.typeMismatch(FailedType.self, context)
        default:
            throw error
        }
    }

}
