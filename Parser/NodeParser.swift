//
//  NodeParser.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public class NodeParser: Parser {

    public enum Options {
        public static let rootNodeNameKey = "Parser.RootNodeNameKey"
    }

    public var codingKey: CodingKey { return node }
    public var codingPath: [CodingKey] { return nodePath }
    public var node: PathNode
    public let json: Any?
    public var succeeded = true
    public var currentIndex = -1
    public var isUnkeyedContainer = false
    public let options: [String: Any]
    public var errors = [ParseError]()
    let parent: Parser?

    init(codingKey: CodingKey, json: Any?, parent: Parser?, options: [String: Any]) {
        self.node = PathNode(codingKey: codingKey)
        self.node.castableJSONTypes = JSONElement.types(for: json)
        self.json = json
        self.parent = parent
        self.options = options
    }

    // MARK: - Creating parsers for JSON sub-elements

    public subscript(key: String) -> Parser {
        let codingKey = PathNode(stringValue: key)!
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return NodeParser(codingKey: codingKey, json: newJSON, parent: self, options: options)
    }

    public subscript(index: Int) -> Parser {
        let codingKey = PathNode(intValue: index)!
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return NodeParser(codingKey: codingKey, json: newJSON, parent: self, options: options)
    }

    public subscript(codingKey: CodingKey) -> Parser {
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return NodeParser(codingKey: codingKey, json: newJSON, parent: self, options: options)
    }

    public func superParser() -> Parser {
        return NodeParser(codingKey: codingKey, json: json, parent: self, options: options)
    }

    public func errorHoldingParser() -> Parser {
        return NodeParser(codingKey: codingKey, json: json, parent: nil, options: options)
    }

    // MARK: - Parsing

    public func required<ParsedType: Parseable>(_ type: ParsedType.Type, min: Int?, max: Int?, countsAreMandatory: Bool) -> ParsedType! {
        let element = parse(type: type, required: true, min: min, max: max, countsAreMandatory: countsAreMandatory)
        if element == nil { swiftParent?.succeeded = false }
        return element
    }

    public func optional<ParsedType: Parseable>(_ type: ParsedType.Type, min: Int?, max: Int?, countsAreMandatory: Bool) -> ParsedType? {
        return parse(type: type, required: false, min: min, max: max, countsAreMandatory: countsAreMandatory)
    }

    public func recordError(_ error: ParseError) {
        guard let parent = parent else { errors.append(error); return }
        parent.recordError(error)
    }

    // MARK: - Path retrieval

    public var nodePath: [PathNode] {
        guard let parent = parent else { return [node] }
        return parent.nodePath + [node]
    }

    public var swiftParent: Parser? {
        guard let parent = parent else { return nil }
        guard parent.node.swiftType != nil else { return parent.swiftParent }
        return parent
    }

    // MARK: - Private methods

    private func parse<ParsedType: Parseable>(type: ParsedType.Type, required: Bool, min: Int?, max: Int?, countsAreMandatory: Bool) -> ParsedType? {
        tagNode(type: type)
        guard !node.castableJSONTypes.isDisjoint(with: node.expectedJSONTypes) || (!required && node.castableJSONTypes == [.null]) else {
            guard required else { return nil }
            recordError(ParseError(path: nodePath, expected: type.jsonTypes, actual: node.castableJSONTypes))
            return nil
        }
        let parsed = ParsedType.init(parser: self)
        if let count = parsed?.parseableElementCount {
            if let min = min, let max = max, min == max, min != count {
                recordError(ParseError(path: nodePath, expected: min, actual: count))
                if countsAreMandatory { return nil }
            } else if let min = min, count < min {
                recordError(ParseError(path: nodePath, minimum: min, actual: count))
                if countsAreMandatory { return nil }
            } else if let max = max, count > max {
                recordError(ParseError(path: nodePath, maximum: max, actual: count))
                if countsAreMandatory { return nil }
            }
        }
        return parsed
    }

    private func tagNode(type: Parseable.Type) {
        node.swiftType = type
        node.expectedJSONTypes = type.jsonTypes
        node.idKey = type.idKey
        node.id = type.id(from: json)
    }
}
