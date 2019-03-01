//
//  ParseError.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public enum ParseErrorType: Equatable {
    case unexpectedJSONType(actual: Set<JSONElement>)
    case countNotExact(expected: Int, actual: Int)
    case countBelowMinimum(minimum: Int, actual: Int)
    case countAboveMaximum(maximum: Int, actual: Int)
    case swiftDecodingError(message: String)
    case other(message: String)
}


public struct ParseError: Error, Equatable {
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

    public init(path: [PathNode], decodingError: DecodingError) {
        self.path = path
        type = .swiftDecodingError(message: decodingError.localizedDescription)
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
        case .swiftDecodingError(let message), .other(let message):
            return message
        }
    }
}
