//
//  ParseError+Equatable.swift
//  ParserTests
//
//  Created by Josh Elkins on 3/1/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation
import Parser


extension ParseError: Equatable {

    public static func == (lhs: ParseError, rhs: ParseError) -> Bool {
        return lhs.path == rhs.path && lhs.type == rhs.type
    }
}


extension ParseErrorType: Equatable {
    public static func ==(lhs: ParseErrorType, rhs: ParseErrorType) -> Bool {
        switch (lhs, rhs) {
        case (.unexpectedJSONType(let lhsActual), .unexpectedJSONType(let rhsActual)):
            return lhsActual == rhsActual
        case (.countNotExact(let lhsExpected, let lhsActual), .countNotExact(let rhsExpected, let rhsActual)):
            return lhsExpected == rhsExpected && lhsActual == rhsActual
        case (.countBelowMinimum(let lhsMinimum, let lhsActual), .countBelowMinimum(let rhsMinimum, let rhsActual)):
            return lhsMinimum == rhsMinimum && lhsActual == rhsActual
        case (.countAboveMaximum(let lhsMaximum, let lhsActual), .countAboveMaximum(let rhsMaximum, let rhsActual)):
            return lhsMaximum == rhsMaximum && lhsActual == rhsActual
        case (.unexpectedRawValue(let lhsValue, let lhsType), .unexpectedRawValue(let rhsValue, let rhsType)):
            return lhsValue == rhsValue && lhsType == rhsType
        case (.swiftDecodingError(let lhsError), .swiftDecodingError(let rhsError)):
            return lhsError == rhsError
        case (.other(let lhsMessage), .other(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}
