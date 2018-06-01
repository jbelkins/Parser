//
//  NodeParser.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public class NodeParser<Key: CodingKey>: Parser {
    public var key: CodingKey
    public var node: PathNode {
        get { return key as! PathNode }
        set { key = newValue }
    }
    public let json: Any?
    public var succeeded = true
    public var currentIndex = -1
    var errors = [ParseError]()
    let parent: NodeParser<Key>?

    init<Key: CodingKey>(node: Key, json: Any?, parent: Parser?) {
        self.key = node
        self.node.castableJSONTypes = JSONElement.types(for: json)
        self.json = json
        self.parent = parent
    }

    // MARK: - Creating parsers for JSON sub-elements

    public subscript(key: String) -> Parser {
        let node = Key(stringValue: key)!
        let newJSON = JSONTools.traverseJSON(json: json, at: node)
        return NodeParser(node: node, json: newJSON, parent: self)
    }

    public subscript(index: Int) -> Parser {
        let node = Key(intValue: index)!
        let newJSON = JSONTools.traverseJSON(json: json, at: node)
        return NodeParser(node: node, json: newJSON, parent: self)
    }

    public subscript(node: Key) -> Parser {
        let newJSON = JSONTools.traverseJSON(json: json, at: key)
        return NodeParser(node: node, json: newJSON, parent: self)
    }

    // MARK: - Parsing

    public func required<ParsedType: Parseable>(_ type: ParsedType.Type, min: Int?, max: Int?) -> ParsedType! {
        let element = parse(type: type, required: true, min: min, max: max)
        if element == nil { swiftParent?.succeeded = false }
        return element
    }

    public func required<ParsedType: Parseable>(_ type: [String: ParsedType].Type, min: Int?, max: Int?) -> [String: ParsedType]! {
        let element = parse(type: type, required: true, min: min, max: max)
        if element == nil { swiftParent?.succeeded = false }
        return element
    }

    public func optional<ParsedType: Parseable>(_ type: ParsedType.Type, min: Int?, max: Int?) -> ParsedType? {
        return parse(type: type, required: false, min: min, max: max)
    }

    public func optional<ParsedType: Parseable>(_ type: [String: ParsedType].Type, min: Int?, max: Int?) -> [String: ParsedType]? {
        return parse(type: type, required: false, min: min, max: max)
    }

    public func recordError(_ error: ParseError) {
        if let parent = parent {
            parent.recordError(error)
        } else {
            errors.append(error)
        }
    }

    // MARK: - Path retrieval

    public var path: [Key] {
        if let parent = parent {
            return parent.path + [key]
        } else {
            return [key]
        }
    }

    public var swiftParent: Parser? {
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

    private func parse<ParsedType: Parseable>(type: ParsedType.Type, required: Bool, min: Int?, max: Int?) -> ParsedType? {
        tagNode(type: type)
        guard node.castableJSONTypes.contains(node.expectedJSONType) else {
            if required {
                let message = "Expected \(type.jsonType.rawValue), got \(node.castableJSONTypes.map { $0.rawValue }.joined(separator: ", "))"
                recordError(ParseError(path: path, message: message))
            }
            return nil
        }
        let parsed = ParsedType.init(parser: self)
        if let count = parsed?.parseableElementCount {
            if let min = min, count < min {
                let message = "\(type.jsonType.rawValue) has \(count) valid \(ParsedType.self) elements, less than min of \(min)"
                recordError(ParseError(path: path, message: message))
                return nil
            }
            if let max = max, count > max {
                let message = "\(type.jsonType.rawValue) has \(count) valid \(ParsedType.self) elements, more than max of \(max)"
                recordError(ParseError(path: path, message: message))
                return nil
            }
        }
        return parsed
    }

    private func tagNode(type: Parseable.Type) {
        node.swiftType = type
        node.expectedJSONType = type.jsonType
        node.idKey = type.idKey
        node.id = type.id(from: json)
    }

    private func allowedJSONTypes(`for` type: Parseable.Type) -> [JSONElement] {
        var types = [type.jsonType]
        if let jsonRawValueType = type as? JSONRawValueType.Type {
            types += jsonRawValueType.extraJSONTypes
        }
        return types
    }
}
