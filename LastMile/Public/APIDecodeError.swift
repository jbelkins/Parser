//
//  APIDecodeError.swift
//  LastMile
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public enum APIDecodeErrorReason {
    case unexpectedJSONType(actual: Set<JSONElement>)
    case countNotExact(expected: Int, actual: Int)
    case countBelowMinimum(minimum: Int, actual: Int)
    case countAboveMaximum(maximum: Int, actual: Int)
    case unexpectedRawValue(value: String, type: String)
    case swiftDecodingError(DecodingError)
    case other(message: String)
}


public struct APIDecodeError {
    public let path: [DecodingPathNode]
    public let reason: APIDecodeErrorReason

    public init(path: [DecodingPathNode], reason: APIDecodeErrorReason) {
        self.path = path
        self.reason = reason
    }

    public init(path: [DecodingPathNode], actual: Set<JSONElement>) {
        self.path = path
        reason = .unexpectedJSONType(actual: actual)
    }

    public init(path: [DecodingPathNode], expected: Int, actual: Int) {
        self.path = path
        reason = .countNotExact(expected: expected, actual: actual)
    }

    public init(path: [DecodingPathNode], minimum: Int, actual: Int) {
        self.path = path
        reason = .countBelowMinimum(minimum: minimum, actual: actual)
    }

    public init(path: [DecodingPathNode], maximum: Int, actual: Int) {
        self.path = path
        reason = .countAboveMaximum(maximum: maximum, actual: actual)
    }

    public init(path: [DecodingPathNode], rawValue: String, type: String) {
        self.path = path
        self.reason = .unexpectedRawValue(value: rawValue, type: type)
    }

    public init(path: [DecodingPathNode], decodingError: DecodingError) {
        self.path = path
        reason = .swiftDecodingError(decodingError)
    }

    public init(path: [DecodingPathNode], message: String) {
        self.path = path
        reason = .other(message: message)
    }
}


extension APIDecodeError: Error {

    public var localizedDescription: String {
        switch reason {
        case .unexpectedJSONType(let actual):
            if actual == [.absent] { return "No value is present" }
            return "Unexpected JSON type: casts to [\(actual.map { $0.rawValue }.joined(separator: ", "))]"
        case .countNotExact(let expected, let actual):
            return "Count not exact: expected \(expected), actual \(actual)"
        case .countBelowMinimum(let minimum, let actual):
            return "Count below min: min \(minimum), actual \(actual)"
        case .countAboveMaximum(let maximum, let actual):
            return "Count above max: max \(maximum), actual \(actual)"
        case .unexpectedRawValue(let value, let type):
            return "Raw value of \"\(value)\" for type \(type) not defined"
        case .swiftDecodingError(let error):
            return "Swift DecodingError: \(error.localizedDescription)"
        case .other(let message):
            return message
        }
    }
}


