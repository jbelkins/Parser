//
//  APIDecodeError.swift
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


