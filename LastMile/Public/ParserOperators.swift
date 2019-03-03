//
//  ParserOperators.swift
//  Parser
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

public func --><ParsedType: Parseable>(lhs: Parser, rhs: ParsedType.Type) -> ParsedType! {
    return lhs.required(ParsedType.self)
}

public func --><ParsedType: Parseable>(lhs: Parser, rhs: ParsedType?.Type) -> ParsedType? {
    return lhs.optional(ParsedType.self)
}

// MARK: --> operator with Create instance

public func --><ParsedType: Parseable & Collection>(lhs: Parser, rhs: CountLimited<ParsedType>) -> ParsedType! {
    return lhs.required(ParsedType.self, min: rhs.min, max: rhs.max, countsAreMandatory: rhs.isMandatory)
}

public func --><ParsedType: Parseable>(lhs: Parser, rhs: CountLimited<ParsedType?>) -> ParsedType? {
    return lhs.optional(ParsedType.self, min: rhs.min, max: rhs.max, countsAreMandatory: rhs.isMandatory)
}
