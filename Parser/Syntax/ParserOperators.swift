//
//  ParserOperators.swift
//  Parser
//
//  Created by Josh Elkins on 2/9/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


infix operator -->

// MARK: - Single element

// MARK: --> operator with type

public func --><ParsedType: Parseable>(lhs: Parser, rhs: ParsedType.Type) -> ParsedType! {
    return lhs.required(rhs)
}

public func --><ParsedType: Parseable>(lhs: Parser, rhs: Optional<ParsedType>.Type) -> ParsedType? {
    return lhs.optional(ParsedType.self)
}

// MARK: --> operator with ParseRequired / ParseOptional instance

public func --><ParsedType: Parseable>(lhs: Parser, rhs: Create<ParsedType>) -> ParsedType! {
    return lhs.required(ParsedType.self)
}

public func --><ParsedType: Parseable>(lhs: Parser, rhs: Create<ParsedType?>) -> ParsedType? {
    return lhs.optional(ParsedType.self)
}

// MARK: - Arrays

public func --><ParsedType: Parseable>(lhs: Parser, rhs: [ParsedType].Type) -> [ParsedType]! {
    return lhs.required(rhs)
}

public func --><ParsedType: Parseable>(lhs: Parser, rhs: Optional<[ParsedType]>.Type) -> [ParsedType]? {
    return lhs.optional([ParsedType].self)
}

// MARK: --> operator with ParseRequired / ParseOptional instance

public func --><ParsedType: Parseable>(lhs: Parser, rhs: Create<[ParsedType]>) -> [ParsedType]! {
    return lhs.required([ParsedType].self, min: rhs.min, max: rhs.max)
}

public func --><ParsedType :Parseable>(lhs: Parser, rhs: Create<[ParsedType]?>) -> [ParsedType]? {
    return lhs.optional([ParsedType].self, min: rhs.min, max: rhs.max)
}

// MARK: - Dictionaries

public func --><ParsedType: Parseable>(lhs: Parser, rhs: [String: ParsedType].Type) -> [String: ParsedType]! {
    return lhs.required(rhs)
}

public func --><ParsedType: Parseable>(lhs: Parser, rhs: Optional<[String: ParsedType]>.Type) -> [String: ParsedType]? {
    return lhs.optional([String: ParsedType].self)
}

// MARK: --> operator with ParseRequired / ParseOptional instance

public func --><ParsedType: Parseable>(lhs: Parser, rhs: Create<[String: ParsedType]>) -> [String: ParsedType]! {
    return lhs.required([String: ParsedType].self, min: rhs.min, max: rhs.max)
}

public func --><ParsedType: Parseable>(lhs: Parser, rhs: Create<[String: ParsedType]?>) -> [String: ParsedType]? {
    return lhs.optional([String: ParsedType].self, min: rhs.min, max: rhs.max)
}


infix operator !->

public func !-><ParsedType: Parseable>(lhs: Parser, rhs: ParsedType.Type) -> ParsedType! {
    return lhs.required(rhs)
}


infix operator ?->

public func ?-><ParsedType: Parseable>(lhs: Parser, rhs: ParsedType.Type) -> ParsedType? {
    return lhs.optional(rhs)
}
