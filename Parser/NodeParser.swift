//
//  NodeParser.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public class NodeParser: Parser {
    public var codingKey: CodingKey { return node }
    public var codingPath: [CodingKey] { return nodePath }
    public var node: PathNode
    public let json: Any?
    public var succeeded = true
    public var currentIndex = -1
    public var isUnkeyedContainer = false
    var errors = [ParseError]()
    let parent: Parser?

    init(codingKey: CodingKey, json: Any?, parent: Parser?) {
        self.node = PathNode(codingKey: codingKey)
        self.node.castableJSONTypes = JSONElement.types(for: json)
        self.json = json
        self.parent = parent
    }

    // MARK: - Creating parsers for JSON sub-elements

    public subscript(key: String) -> Parser {
        let codingKey = PathNode(stringValue: key)!
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return NodeParser(codingKey: codingKey, json: newJSON, parent: self)
    }

    public subscript(index: Int) -> Parser {
        let codingKey = PathNode(intValue: index)!
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return NodeParser(codingKey: codingKey, json: newJSON, parent: self)
    }

    public subscript(codingKey: CodingKey) -> Parser {
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return NodeParser(codingKey: codingKey, json: newJSON, parent: self)
    }

    // MARK: - Parsing

    public func required<ParsedType: Parseable>(_ type: ParsedType.Type, min: Int?, max: Int?) -> ParsedType! {
        let element = parse(type: type, required: true, min: min, max: max)
        if element == nil { swiftParent?.succeeded = false }
        return element
    }

    public func optional<ParsedType: Parseable>(_ type: ParsedType.Type, min: Int?, max: Int?) -> ParsedType? {
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

    public var nodePath: [PathNode] {
        if let parent = parent {
            return parent.nodePath + [node]
        } else {
            return [node]
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
                recordError(ParseError(path: nodePath, message: message))
            }
            return nil
        }
        let parsed = ParsedType.init(parser: self)
        if let count = parsed?.parseableElementCount {
            if let min = min, count < min {
                let message = "\(type.jsonType.rawValue) has \(count) valid \(ParsedType.self) elements, less than min of \(min)"
                recordError(ParseError(path: nodePath, message: message))
                return nil
            }
            if let max = max, count > max {
                let message = "\(type.jsonType.rawValue) has \(count) valid \(ParsedType.self) elements, more than max of \(max)"
                recordError(ParseError(path: nodePath, message: message))
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
