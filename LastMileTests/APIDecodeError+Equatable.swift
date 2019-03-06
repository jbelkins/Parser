//
//  APIDecodeError+Equatable.swift
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

    //  For the purposes of testing, an APIDecodeError is equal to another if:
    //  1) the coding keys in `codingPath` are equal (string and int values only)
    //  2) the reasons are equal.
    public static func == (lhs: APIDecodeError, rhs: APIDecodeError) -> Bool {
        return lhs.codingPath.keysAreEqual(rhs.codingPath) && lhs.reason == rhs.reason
    }
}


extension Array where Element == CodingKey {

    fileprivate func keysAreEqual(_ other: [CodingKey]) -> Bool {
        guard self.count == other.count else { return false }
        for (lh, rh) in zip(self, other) {
            if lh.stringValue != rh.stringValue || lh.intValue != rh.intValue { return false }
        }
        return true
    }
}
