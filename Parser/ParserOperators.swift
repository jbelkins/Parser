//
//  ParserOperators.swift
//  Parser
//
//  Created by Josh Elkins on 2/9/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


infix operator -->

public func --><ParsedType: Parseable>(lhs: Parser, rhs: ParsedType.Type) -> ParsedType! {
    return lhs.required(rhs)
}

public func --><ParsedType: Parseable>(lhs: Parser, rhs: Optional<ParsedType>.Type) -> ParsedType? {
    return lhs.optional(ParsedType.self)
}


infix operator !->

public func !-><ParsedType: Parseable>(lhs: Parser, rhs: ParsedType.Type) -> ParsedType! {
    return lhs.required(rhs)
}


infix operator ?->

public func ?-><ParsedType: Parseable>(lhs: Parser, rhs: ParsedType.Type) -> ParsedType? {
    return lhs.optional(ParsedType.self)
}
