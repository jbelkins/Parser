//
//  Operators.swift
//  LastMile
//
//  Created by Josh Elkins on 2/9/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


precedencegroup ParseOperationsGroup {
    higherThan: NilCoalescingPrecedence
}

infix operator --> : ParseOperationsGroup

// MARK: - Single element

// MARK: --> operator with type

public func --><DecodedType: APIDecodable>(lhs: APIDecoder, rhs: DecodedType.Type) -> DecodedType! {
    return lhs.required(DecodedType.self)
}

public func --><DecodedType: APIDecodable>(lhs: APIDecoder, rhs: DecodedType?.Type) -> DecodedType? {
    return lhs.optional(DecodedType.self)
}

// MARK: --> operator with Create instance

public func --><DecodedType: APIDecodable & Collection>(lhs: APIDecoder, rhs: CountLimited<DecodedType>) -> DecodedType! {
    return lhs.required(DecodedType.self, min: rhs.min, max: rhs.max, countsAreMandatory: rhs.isMandatory)
}

public func --><DecodedType: APIDecodable>(lhs: APIDecoder, rhs: CountLimited<DecodedType?>) -> DecodedType? {
    return lhs.optional(DecodedType.self, min: rhs.min, max: rhs.max, countsAreMandatory: rhs.isMandatory)
}
