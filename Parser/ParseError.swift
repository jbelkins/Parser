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
    case countBelowMinimum(minimum: Int, actual: Int)
    case countAboveMaximum(maximum: Int, actual: Int)
    case other(message: String)
}


public struct ParseError {
    public let path: [PathNode]
    public let type: ParseErrorType

    init(path: [PathNode], expected: JSONElement, actual: Set<JSONElement>) {
        self.path = path
        type = .unexpectedJSONType(expected: expected, actual: actual)
    }

    init(path: [PathNode], minimum: Int, actual: Int) {
        self.path = path
        type = .countBelowMinimum(minimum: minimum, actual: actual)
    }

    init(path: [PathNode], maximum: Int, actual: Int) {
        self.path = path
        type = .countAboveMaximum(maximum: maximum, actual: actual)
    }

    init(path: [PathNode], message: String) {
        self.path = path
        type = .other(message: message)
    }
}


extension ParseError: Error {
    var localizedDescription: String {
        switch type {
        case .unexpectedJSONType(let expected, let actual):
            return "Unexpected JSON type: expected \(expected.rawValue), got [\(actual.map { $0.rawValue }.joined(separator: ", "))]"
        case .countBelowMinimum(let minimum, let actual):
            return "Count below min: min \(minimum), actual \(actual)"
        case .countAboveMaximum(let maximum, let actual):
            return "Count above max: max \(maximum), actual \(actual)"
        case .other(let message):
            return message
        }
    }
}


//extension ParseError: Equatable {
//
//    public static func ==(lhs: ParseError, rhs: ParseError) -> Bool {
//        guard lhs.path == rhs.path else { return false }
//        switch lhs.type {
//        case .unexpectedJSONType(let lhsExpected, let lhsActual):
//            guard case .unexpectedJSONType(let rhsExpected, let rhsActual) = rhs.type else { return false }
//            return lhsActual == rhsActual && Set(lhsActual) ==
//        }
//    }
//}
