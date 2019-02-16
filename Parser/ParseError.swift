//
//  ParseError.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public enum ParseErrorType: Equatable {
    case unexpectedJSONType(expected: JSONElement, actual: Set<JSONElement>)
    case countNotExact(expected: Int, actual: Int)
    case countBelowMinimum(minimum: Int, actual: Int)
    case countAboveMaximum(maximum: Int, actual: Int)
    case swiftDecodingError(message: String)
    case other(message: String)
}


public struct ParseError: Equatable {
    public let path: [PathNode]
    public let type: ParseErrorType

    public init(path: [PathNode], expected: JSONElement, actual: Set<JSONElement>) {
        self.path = path
        type = .unexpectedJSONType(expected: expected, actual: actual)
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

    public init(path: [PathNode], message: String) {
        self.path = path
        type = .other(message: message)
    }
}


extension ParseError: Error {
    var localizedDescription: String {
        switch type {
        case .unexpectedJSONType(let expected, let actual):
            return "Unexpected JSON type: expected \(expected.rawValue), got [\(actual.map { $0.rawValue }.joined(separator: ", "))]"
        case .countNotExact(let expected, let actual):
            return "Count not exact: expected \(expected), actual \(actual)"
        case .countBelowMinimum(let minimum, let actual):
            return "Count below min: min \(minimum), actual \(actual)"
        case .countAboveMaximum(let maximum, let actual):
            return "Count above max: max \(maximum), actual \(actual)"
        case .swiftDecodingError(let message), .other(let message):
            return message
        }
    }
}
