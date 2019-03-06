//
//  ParseError+Equatable.swift
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
import LastMile


extension APIDecodeError: Equatable {

    public static func == (lhs: APIDecodeError, rhs: APIDecodeError) -> Bool {
        return lhs.path == rhs.path && lhs.reason == rhs.reason
    }
}


extension APIDecodeErrorReason: Equatable {
    public static func ==(lhs: APIDecodeErrorReason, rhs: APIDecodeErrorReason) -> Bool {
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
