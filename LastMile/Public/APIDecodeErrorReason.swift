//
//  APIDecodeErrorReason.swift
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


extension APIDecodeErrorReason: CustomStringConvertible {

    public var description: String {
        switch self {
        case .unexpectedJSONType(let actual):
            if actual == .absent { return "No value is present" }
            return "Unexpectedly found a \(actual)"
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
