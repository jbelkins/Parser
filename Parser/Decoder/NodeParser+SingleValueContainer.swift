//
//  NodeParser+SingleValueContainer.swift
//  Parser
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension NodeParser: SingleValueDecodingContainer {

    public func decode(_ type: Bool.Type) throws -> Bool {
        guard let bool = required(Bool.self, min: nil, max: nil) else {
            throw NodeError.error("Not a Bool")
        }
        return bool
    }

    public func decode(_ type: String.Type) throws -> String {
        guard let string = required(String.self, min: nil, max: nil) else {
            throw NodeError.error("Not a String")
        }
        return string
    }

    public func decode(_ type: Double.Type) throws -> Double {
        guard let double = required(Double.self, min: nil, max: nil) else {
            throw NodeError.error("Not a Double")
        }
        return double
    }

    public func decode(_ type: Float.Type) throws -> Float {
        return 0
    }

    public func decode(_ type: Int.Type) throws -> Int {
        guard let int = required(Int.self, min: nil, max: nil) else {
            throw NodeError.error("Not a Int")
        }
        return int
    }

    public func decode(_ type: Int8.Type) throws -> Int8 {
        return 0
    }

    public func decode(_ type: Int16.Type) throws -> Int16 {
        return 0
    }

    public func decode(_ type: Int32.Type) throws -> Int32 {
        return 0
    }

    public func decode(_ type: Int64.Type) throws -> Int64 {
        return 0
    }

    public func decode(_ type: UInt.Type) throws -> UInt {
        return 0
    }

    public func decode(_ type: UInt8.Type) throws -> UInt8 {
        return 0
    }

    public func decode(_ type: UInt16.Type) throws -> UInt16 {
        return 0
    }

    public func decode(_ type: UInt32.Type) throws -> UInt32 {
        return 0
    }

    public func decode(_ type: UInt64.Type) throws -> UInt64 {
        return 0
    }
}
