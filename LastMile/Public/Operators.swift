//
//  Operators.swift
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


precedencegroup ParseOperationsGroup {
    higherThan: NilCoalescingPrecedence
}

infix operator --> : ParseOperationsGroup

// MARK: - Single element

// MARK: --> operator with type

public func --><DecodedType: APIDecodable>(lhs: APIDecoder, rhs: DecodedType.Type) -> DecodedType! {
    return lhs.decodeRequired(DecodedType.self)
}

public func --><DecodedType: APIDecodable>(lhs: APIDecoder, rhs: DecodedType?.Type) -> DecodedType? {
    return lhs.decodeOptional(DecodedType.self)
}

// MARK: --> operator with Create instance

public func --><DecodedType: APIDecodable & Collection>(lhs: APIDecoder, rhs: CountLimited<DecodedType>) -> DecodedType! {
    return lhs.decodeRequired(DecodedType.self, min: rhs.min, max: rhs.max, countsAreMandatory: rhs.isMandatory)
}

public func --><DecodedType: APIDecodable>(lhs: APIDecoder, rhs: CountLimited<DecodedType?>) -> DecodedType? {
    return lhs.decodeOptional(DecodedType.self, min: rhs.min, max: rhs.max, countsAreMandatory: rhs.isMandatory)
}
