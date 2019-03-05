//
//  APIDecodeError.swift
//  LastMile
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public enum APIDecodeErrorReason {
    case unexpectedJSONType(actual: JSONElement)
    case countNotExact(expected: Int, actual: Int)
    case countBelowMinimum(minimum: Int, actual: Int)
    case countAboveMaximum(maximum: Int, actual: Int)
    case unexpectedRawValue(value: String, type: String)
    case numericOverflow(value: String, type: String)
    case lossOfPrecision(value: String, type: String)
    case swiftDecodingError(DecodingError)
    case other(message: String)
}


public struct APIDecodeError {
    public let path: [APICodingKey]
    public let reason: APIDecodeErrorReason
    public var codingPath: [CodingKey] { return Array(path.dropFirst())}
    public var codingKey: CodingKey { return path.last! }

    public init(path: [APICodingKey], reason: APIDecodeErrorReason) {
        self.path = path
        self.reason = reason
    }

    public init(path: [APICodingKey], actual: JSONElement) {
        self.path = path
        reason = .unexpectedJSONType(actual: actual)
    }

    public init(path: [APICodingKey], expected: Int, actual: Int) {
        self.path = path
        reason = .countNotExact(expected: expected, actual: actual)
    }

    public init(path: [APICodingKey], minimum: Int, actual: Int) {
        self.path = path
        reason = .countBelowMinimum(minimum: minimum, actual: actual)
    }

    public init(path: [APICodingKey], maximum: Int, actual: Int) {
        self.path = path
        reason = .countAboveMaximum(maximum: maximum, actual: actual)
    }

    public init(path: [APICodingKey], rawValue: String, type: String) {
        self.path = path
        self.reason = .unexpectedRawValue(value: rawValue, type: type)
    }

    public init(path: [APICodingKey], value: String, overflowedType: String) {
        self.path = path
        self.reason = .numericOverflow(value: value, type: overflowedType)
    }

    public init(path: [APICodingKey], value: String, impreciseType: String) {
        self.path = path
        self.reason = .lossOfPrecision(value: value, type: impreciseType)
    }

    public init(path: [APICodingKey], swiftDecodingError: DecodingError) {
        self.path = path
        reason = .swiftDecodingError(swiftDecodingError)
    }

    public init(path: [APICodingKey], message: String) {
        self.path = path
        reason = .other(message: message)
    }
}


extension APIDecodeError: Error {

    public var localizedDescription: String {
        switch reason {
        case .unexpectedJSONType(let actual):
            if actual == .absent { return "No value is present" }
            return "Unexpected JSON type: casts to \(actual)"
        case .countNotExact(let expected, let actual):
            return "Count not exact: expected \(expected), actual \(actual)"
        case .countBelowMinimum(let minimum, let actual):
            return "Count below min: min \(minimum), actual \(actual)"
        case .countAboveMaximum(let maximum, let actual):
            return "Count above max: max \(maximum), actual \(actual)"
        case .unexpectedRawValue(let value, let type):
            return "Raw value of \"\(value)\" for type \(type) not defined"
        case .numericOverflow(let value, let type):
            return "Value \(value) does not fit in \(type)"
        case .lossOfPrecision(let value, let type):
            return "Type \(type) does not have precision to represent \(value)"
        case .swiftDecodingError(let decodingError):
            return "Swift DecodingError: \(decodingError)"
        case .other(let message):
            return message
        }
    }
}


