//
//  DecodingError+Equatable.swift
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


extension DecodingError: Equatable {

    public static func ==(lhs: DecodingError, rhs: DecodingError) -> Bool {
        return areCasesEqual(lhs: lhs, rhs: rhs)
    }

    // Returns true if the error case and coding path match, false otherwise.
    public static func areCasesEqual(lhs: DecodingError, rhs: DecodingError) -> Bool {
        switch (lhs, rhs) {
        case (.dataCorrupted(let lhsContext), .dataCorrupted(let rhsContext)),
             (.keyNotFound(_, let lhsContext), .keyNotFound(_, let rhsContext)),
             (.typeMismatch(_, let lhsContext), .typeMismatch(_, let rhsContext)),
             (.valueNotFound(_, let lhsContext), .valueNotFound(_, let rhsContext)):
            return lhsContext.codingPath.isSamePath(as: rhsContext.codingPath)
        default: return false
        }
    }
}


fileprivate extension Array where Element == CodingKey {

    func isSamePath(`as` other: [CodingKey]) -> Bool {
        guard count == other.count else { return false }
        for (lhs, rhs) in zip(self, other) {
            if !(lhs == rhs) { return false }
        }
        return true
    }
}

fileprivate extension CodingKey {

    static func ==(lhs: CodingKey, rhs: CodingKey) -> Bool {
        return lhs.stringValue == rhs.stringValue && lhs.intValue == rhs.intValue
    }
}
