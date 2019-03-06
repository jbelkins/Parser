//
//  APIDecodeError.swift
//  LastMile
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public struct APIDecodeError {
    public let path: [APICodingKey]
    public let reason: APIDecodeErrorReason
    public var codingPath: [CodingKey] { return Array(path.dropFirst()) }
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


extension APIDecodeError: CustomStringConvertible, Error {

    public var description: String {
        return "\(path.taggedJSONPath) : \(reason)"
    }

    public var localizedDescription: String {
        return description
    }
}


