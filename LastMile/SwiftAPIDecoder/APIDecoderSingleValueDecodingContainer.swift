//
//  APIDecoderSingleValueDecodingContainer.swift
//  LastMile
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

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
        return try decodeAndReturnOrThrow(swiftDecodableType: T.self)
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

    private func decodeAndReturnOrThrow<DecodedType: Decodable>(swiftDecodableType: DecodedType.Type) throws -> DecodedType {
        let isolatedDecoder = decoder.errorHoldingDecoder()
        guard let value = isolatedDecoder.decodeRequired(swiftDecodable: DecodedType.self) else {
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
