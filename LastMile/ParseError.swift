//
//  ParseError.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public enum ParseErrorType {
    case unexpectedJSONType(actual: Set<JSONElement>)
    case countNotExact(expected: Int, actual: Int)
    case countBelowMinimum(minimum: Int, actual: Int)
    case countAboveMaximum(maximum: Int, actual: Int)
    case unexpectedRawValue(value: String, type: String)
    case swiftDecodingError(DecodingError)
    case other(message: String)
}


public struct ParseError: Error {
    public let path: [PathNode]
    public let type: ParseErrorType

    public init(path: [PathNode], actual: Set<JSONElement>) {
        self.path = path
        type = .unexpectedJSONType(actual: actual)
    }

    public init(path: [PathNode], expected: Int, actual: Int) {
        self.path = path
        type = .countNotExact(expected: expected, actual: actual)
    }

    public init(path: [PathNode], minimum: Int, actual: Int) {
        self.path = path
        type = .countBelowMinimum(minimum: minimum, actual: actual)
    }

    public init(path: [PathNode], maximum: Int, actual: Int) {
        self.path = path
        type = .countAboveMaximum(maximum: maximum, actual: actual)
    }

    public init(path: [PathNode], rawValue: String, type: String) {
        self.path = path
        self.type = .unexpectedRawValue(value: rawValue, type: type)
    }

    public init(path: [PathNode], decodingError: DecodingError) {
        self.path = path
        type = .swiftDecodingError(decodingError)
    }

    public init(path: [PathNode], message: String) {
        self.path = path
        type = .other(message: message)
    }
}


extension ParseError {

    public var localizedDescription: String {
        switch type {
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


