//
//  Parser.swift
//  Parser
//
//  Created by Josh Elkins on 2/10/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public protocol Parser: class {
    var node: PathNode { get }
    var path: [PathNode] { get }
    var json: Any? { get }
    var swiftParent: Parser? { get }
    subscript(key: String) -> Parser { get }
    subscript(index: Int) -> Parser { get }
    func required<ParsedType: Parseable>(_ type: ParsedType.Type) -> ParsedType!
    func optional<ParsedType: Parseable>(_ type: ParsedType.Type) -> ParsedType?
    func required<ParsedType: Parseable>(_ type: [ParsedType].Type) -> [ParsedType]!
    func optional<ParsedType: Parseable>(_ type: [ParsedType].Type) -> [ParsedType]?
    func recordError(_ error: ParseError)
    var succeeded: Bool { get set }
}
