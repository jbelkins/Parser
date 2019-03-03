//
//  NodeParser+SingleValueContainer.swift
//  LastMile
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


class SingleValueNodeParser: SingleValueDecodingContainer {
    var codingPath: [CodingKey] { return parser.nodePath }
    let parser: Parser

    init(parser: Parser) {
        self.parser = parser
    }

    func decodeNil() -> Bool {
        return parser.json is NSNull
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        guard let value = parser.decode(T.self) else {
            try throwTypeMismatch(for: type)
        }
        return value
    }

    public func decode(_ type: Bool.Type) throws -> Bool {
        guard let bool = parser.required(Bool.self) else {
            try throwTypeMismatch(for: type)
        }
        return bool
    }

    public func decode(_ type: String.Type) throws -> String {
        guard let string = parser.required(String.self) else {
            try throwTypeMismatch(for: type)
        }
        return string
    }

    public func decode(_ type: Double.Type) throws -> Double {
        guard let double = parser.required(Double.self) else {
            try throwTypeMismatch(for: type)
        }
        return double
    }

    public func decode(_ type: Float.Type) throws -> Float {
        guard let float = parser.required(Float.self) else {
            try throwTypeMismatch(for: type)
        }
        return float
    }

    public func decode(_ type: Int.Type) throws -> Int {
        guard let int = parser.required(Int.self) else {
            try throwTypeMismatch(for: type)
        }
        return int
    }

    public func decode(_ type: Int8.Type) throws -> Int8 {
        guard let int8 = parser.required(Int8.self) else {
            try throwTypeMismatch(for: type)
        }
        return int8
    }

    public func decode(_ type: Int16.Type) throws -> Int16 {
        guard let int16 = parser.required(Int16.self) else {
            try throwTypeMismatch(for: type)
        }
        return int16
    }

    public func decode(_ type: Int32.Type) throws -> Int32 {
        guard let int32 = parser.required(Int32.self) else {
            try throwTypeMismatch(for: type)
        }
        return int32
    }

    public func decode(_ type: Int64.Type) throws -> Int64 {
        guard let int64 = parser.required(Int64.self) else {
            try throwTypeMismatch(for: type)
        }
        return int64
    }

    public func decode(_ type: UInt.Type) throws -> UInt {
        guard let uint = parser.required(UInt.self) else {
            try throwTypeMismatch(for: type)
        }
        return uint
    }

    public func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard let uint8 = parser.required(UInt8.self) else {
            try throwTypeMismatch(for: type)
        }
        return uint8
    }

    public func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard let uint16 = parser.required(UInt16.self) else {
            try throwTypeMismatch(for: type)
        }
        return uint16
    }

    public func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard let uint32 = parser.required(UInt32.self) else {
            try throwTypeMismatch(for: type)
        }
        return uint32
    }

    public func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard let uint64 = parser.required(UInt64.self) else {
            try throwTypeMismatch(for: type)
        }
        return uint64
    }

    private func throwTypeMismatch(`for` type: Any.Type) throws -> Never {
        let parseError = ParseError(path: parser.nodePath, actual: parser.node.castableJSONTypes)
        throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: parseError.localizedDescription))
    }
}
