//
//  APIDecodeErrorReason.swift
//  LastMile
//
//  Created by Josh Elkins on 3/6/19.
//  Copyright © 2019 Parser. All rights reserved.
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
