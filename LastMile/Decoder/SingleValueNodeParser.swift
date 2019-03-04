//
//  NodeParser+SingleValueContainer.swift
//  LastMile
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


class SingleValueNodeParser: SingleValueDecodingContainer {
    var codingPath: [CodingKey] { return decoder.nodePath }
    let decoder: APIDecoder

    init(decoder: APIDecoder) {
        self.decoder = decoder
    }

    func decodeNil() -> Bool {
        return decoder.json is NSNull
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Swift.Decodable {
        guard let value = decoder.decodeRequired(swiftDecodable: T.self) else {
            try throwTypeMismatch(for: type)
        }
        return value
    }

    public func decode(_ type: Bool.Type) throws -> Bool {
        guard let bool = decoder.decodeRequired(Bool.self) else {
            try throwTypeMismatch(for: type)
        }
        return bool
    }

    public func decode(_ type: String.Type) throws -> String {
        guard let string = decoder.decodeRequired(String.self) else {
            try throwTypeMismatch(for: type)
        }
        return string
    }

    public func decode(_ type: Double.Type) throws -> Double {
        guard let double = decoder.decodeRequired(Double.self) else {
            try throwTypeMismatch(for: type)
        }
        return double
    }

    public func decode(_ type: Float.Type) throws -> Float {
        guard let float = decoder.decodeRequired(Float.self) else {
            try throwTypeMismatch(for: type)
        }
        return float
    }

    public func decode(_ type: Int.Type) throws -> Int {
        guard let int = decoder.decodeRequired(Int.self) else {
            try throwTypeMismatch(for: type)
        }
        return int
    }

    public func decode(_ type: Int8.Type) throws -> Int8 {
        guard let int8 = decoder.decodeRequired(Int8.self) else {
            try throwTypeMismatch(for: type)
        }
        return int8
    }

    public func decode(_ type: Int16.Type) throws -> Int16 {
        guard let int16 = decoder.decodeRequired(Int16.self) else {
            try throwTypeMismatch(for: type)
        }
        return int16
    }

    public func decode(_ type: Int32.Type) throws -> Int32 {
        guard let int32 = decoder.decodeRequired(Int32.self) else {
            try throwTypeMismatch(for: type)
        }
        return int32
    }

    public func decode(_ type: Int64.Type) throws -> Int64 {
        guard let int64 = decoder.decodeRequired(Int64.self) else {
            try throwTypeMismatch(for: type)
        }
        return int64
    }

    public func decode(_ type: UInt.Type) throws -> UInt {
        guard let uint = decoder.decodeRequired(UInt.self) else {
            try throwTypeMismatch(for: type)
        }
        return uint
    }

    public func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard let uint8 = decoder.decodeRequired(UInt8.self) else {
            try throwTypeMismatch(for: type)
        }
        return uint8
    }

    public func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard let uint16 = decoder.decodeRequired(UInt16.self) else {
            try throwTypeMismatch(for: type)
        }
        return uint16
    }

    public func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard let uint32 = decoder.decodeRequired(UInt32.self) else {
            try throwTypeMismatch(for: type)
        }
        return uint32
    }

    public func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard let uint64 = decoder.decodeRequired(UInt64.self) else {
            try throwTypeMismatch(for: type)
        }
        return uint64
    }

    private func throwTypeMismatch(`for` type: Any.Type) throws -> Never {
        let parseError = APIDecodeError(path: decoder.nodePath, actual: decoder.node.castableJSONTypes)
        throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: parseError.localizedDescription))
    }
}
