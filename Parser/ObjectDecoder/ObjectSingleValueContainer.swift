//
//  ObjectSingleValueContainer.swift
//  Parser
//
//  Created by Josh Elkins on 5/28/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation

class ObjectSingleValueContainer: SingleValueDecodingContainer {
    let jsonObject: Any?
    let codingPath: [CodingKey]

    init(codingPath: [CodingKey], jsonObject: Any?) {
        self.codingPath = codingPath
        self.jsonObject = jsonObject
    }

    func decodeNil() -> Bool {
        return jsonObject is NSNull
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        guard let nsNumber = jsonObject as? NSNumber, CFBooleanGetTypeID() == CFGetTypeID(nsNumber) else {
            try throwTypeMismatch(for: type)
        }
        return nsNumber.boolValue
    }

    func decode(_ type: String.Type) throws -> String {
        guard let string = jsonObject as? String else {
            try throwTypeMismatch(for: type)
        }
        return string
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        guard let nsNumber = jsonObject as? NSNumber, let double = Double(exactly: nsNumber) else {
            try throwTypeMismatch(for: type)
        }
        return double
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        guard let nsNumber = jsonObject as? NSNumber, let float = Float(exactly: nsNumber) else {
            try throwTypeMismatch(for: type)
        }
        return float
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        guard let nsNumber = jsonObject as? NSNumber, let int = Int(exactly: nsNumber) else {
            try throwTypeMismatch(for: type)
        }
        return int
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        guard let nsNumber = jsonObject as? NSNumber, let int8 = Int8(exactly: nsNumber) else {
            try throwTypeMismatch(for: type)
        }
        return int8
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        guard let nsNumber = jsonObject as? NSNumber, let int16 = Int16(exactly: nsNumber) else {
            try throwTypeMismatch(for: type)
        }
        return int16
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        guard let nsNumber = jsonObject as? NSNumber, let int32 = Int32(exactly: nsNumber) else {
            try throwTypeMismatch(for: type)
        }
        return int32
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        guard let nsNumber = jsonObject as? NSNumber, let int64 = Int64(exactly: nsNumber) else {
            try throwTypeMismatch(for: type)
        }
        return int64
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        guard let nsNumber = jsonObject as? NSNumber, let uint = UInt(exactly: nsNumber) else {
            try throwTypeMismatch(for: type)
        }
        return uint
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard let nsNumber = jsonObject as? NSNumber, let uint8 = UInt8(exactly: nsNumber) else {
            try throwTypeMismatch(for: type)
        }
        return uint8
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard let nsNumber = jsonObject as? NSNumber, let uint16 = UInt16(exactly: nsNumber) else {
            try throwTypeMismatch(for: type)
        }
        return uint16
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard let nsNumber = jsonObject as? NSNumber, let uint32 = UInt32(exactly: nsNumber) else {
            try throwTypeMismatch(for: type)
        }
        return uint32
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard let nsNumber = jsonObject as? NSNumber, let uint64 = UInt64(exactly: nsNumber) else {
            try throwTypeMismatch(for: type)
        }
        return uint64
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        let decoder = _ObjectDecoder(codingPath: codingPath, jsonObject: jsonObject)
        return try T.init(from: decoder)
    }

    // MARK: - Private functions

    private func throwTypeMismatch(`for` type: Any.Type) throws -> Never {
        throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type), not a \(type)"))
    }
}
