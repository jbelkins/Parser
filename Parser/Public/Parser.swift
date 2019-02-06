//
//  Parser.swift
//  Parser
//
//  Created by Josh Elkins on 2/10/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public protocol Parser: class, Decoder, UnkeyedDecodingContainer, SingleValueDecodingContainer {
    var json: Any? { get }
    var codingKey: CodingKey { get }
    var codingPath: [CodingKey] { get }
    var node: PathNode { get }
    var nodePath: [PathNode] { get }
    var swiftParent: Parser? { get }
    subscript(key: String) -> Parser { get }
    subscript(index: Int) -> Parser { get }
    subscript(codingKey: CodingKey) -> Parser { get }
    func required<ParsedType: Parseable>(_ type: ParsedType.Type, min: Int?, max: Int?) -> ParsedType!
    func optional<ParsedType: Parseable>(_ type: ParsedType.Type, min: Int?, max: Int?) -> ParsedType?
    func recordError(_ error: ParseError)
    var succeeded: Bool { get set }
    var isUnkeyedContainer: Bool { get set }
}


public extension Parser {

    func required<ParsedType: Parseable>(_ type: ParsedType.Type) -> ParsedType! {
        return required(type, min: nil, max: nil)
    }

    func optional<ParsedType: Parseable>(_ type: ParsedType.Type) -> ParsedType? {
        return optional(type, min: nil, max: nil)
    }
}