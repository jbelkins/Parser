//
//  NodeParser.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public class NodeParser: Parser {
    public var node: PathNode
    public let json: Any?
    let isRequired: Bool
    public var succeeded = true
    var errors = [ParseError]()
    let parent: NodeParser?

    init(node: PathNode, json: Any?, isRequired: Bool, parent: NodeParser?) {
        self.node = node
        self.json = json
        self.isRequired = isRequired
        self.parent = parent
    }

    // MARK: - Creating parsers for JSON sub-elements

    public subscript(key: String) -> NodeParser {
        let newNode = PathNode(hashKey: key, swiftType: nil)
        let newJSON = JSONTools.traverseJSON(json: json, at: newNode)
        return NodeParser(node: newNode, json: newJSON, isRequired: isRequired, parent: self)
    }

    public subscript(index: Int) -> NodeParser {
        let newNode = PathNode(arrayIndex: index, swiftType: nil)
        let newJSON = JSONTools.traverseJSON(json: json, at: newNode)
        return NodeParser(node: newNode, json: newJSON, isRequired: isRequired, parent: self)
    }

    // MARK: - Parsing

    public func required<ParsedType: Parseable>(_ type: ParsedType.Type) -> ParsedType! {
        let element = parse(type: type, required: true)
        if element == nil { swiftParent?.succeeded = false }
        return element
    }

    public func optional<ParsedType: Parseable>(_ type: ParsedType.Type) -> ParsedType? {
        return parse(type: type, required: false)
    }

    public func recordError(_ error: ParseError) {
        if let parent = parent {
            parent.recordError(error)
        } else {
            errors.append(error)
        }
    }

    // MARK: - Path retrieval

    public var path: [PathNode] {
        if let parent = parent {
            return parent.path + [node]
        } else {
            return [node]
        }
    }

    var swiftParent: NodeParser? {
        if let parent = parent {
            if parent.node.swiftType != nil {
                return parent
            } else {
                return parent.swiftParent
            }
        } else {
            return nil
        }
    }

    // MARK: - Private methods

    private func parse<ParsedType: Parseable>(type: ParsedType.Type, required: Bool) -> ParsedType? {
        tagNode(type: type)
        let element: ParsedType?
        if json == nil {
            element = nil
            if required {
                let error = ParseError(path: path, message: "Missing \(ParsedType.self)")
                recordError(error)
            }
        } else {
            element = ParsedType.init(parser: self)
        }
        return element
    }

    private func tagNode(type: Parseable.Type) {
        node.swiftType = type
        node.idKey = type.idKey
        node.id = type.id(from: json)
    }
}
