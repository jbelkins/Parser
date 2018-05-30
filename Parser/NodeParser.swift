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
    public var succeeded = true
    var errors = [ParseError]()
    let parent: Parser?

    init(node: PathNode, json: Any?, parent: Parser?) {
        self.node = node
        self.node.castableJSONTypes = JSONElement.types(for: json)
        self.json = json
        self.parent = parent
    }

    convenience init(index: Int, parent: Parser) {
        let newNode = PathNode(arrayIndex: index, swiftType: nil)
        let json = JSONTools.traverseJSON(json: parent.json, at: newNode)
        self.init(node: newNode, json: json, parent: parent)
    }

    convenience init(key: String, parent: Parser) {
        let newNode = PathNode(hashKey: key, swiftType: nil)
        let json = JSONTools.traverseJSON(json: parent.json, at: newNode)
        self.init(node: newNode, json: json, parent: parent)
    }

    // MARK: - Creating parsers for JSON sub-elements

    public subscript(key: String) -> Parser {
        return NodeParser(key: key, parent: self)
    }

    public subscript(index: Int) -> Parser {
        return NodeParser(index: index, parent: self)
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

    public var path: [PathNode] {
        if let parent = parent {
            return parent.path + [node]
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

    private func parse<ParsedType: Parseable>(type: [String: ParsedType].Type, required: Bool, min: Int?, max: Int?) -> [String: ParsedType]? {
        tagNode(dictionaryElementType: ParsedType.self)
        guard let dictJSON = json as? [String: Any] else {
            if required {
                let message = "Expected \(JSONElement.object.rawValue), got \(node.castableJSONTypes.map { $0.rawValue }.joined(separator: ", "))"
                recordError(ParseError(path: path, message: message))
            }
            return nil
        }
        var dict: [String: ParsedType?] = [:]
        for key in dictJSON.keys {
            dict[key] = NodeParser(key: key, parent: self).required(ParsedType.self)
        }
        let dictionaryWithoutNilValues = dict.filter { $0.value != nil }.mapValues { $0! }
        if let min = min, dictionaryWithoutNilValues.count < min {
            let message = "Array has \(dictionaryWithoutNilValues.count) valid \(ParsedType.self) elements, less than min of \(min)"
            recordError(ParseError(path: path, message: message))
            return nil
        }
        if let max = max, dictionaryWithoutNilValues.count > max {
            let message = "Array has \(dictionaryWithoutNilValues.count) valid \(ParsedType.self) elements, more than max of \(max)"
            recordError(ParseError(path: path, message: message))
            return nil
        }
        return dictionaryWithoutNilValues
    }

    private func tagNode(type: Parseable.Type) {
        node.swiftType = type
        node.expectedJSONType = type.jsonType
        node.idKey = type.idKey
        node.id = type.id(from: json)
    }

    private func tagNode<DictionaryElementType: Parseable>(dictionaryElementType: DictionaryElementType.Type) {
        node.swiftType = [String: DictionaryElementType].self
        node.expectedJSONType = .object
    }

    private func allowedJSONTypes(`for` type: Parseable.Type) -> [JSONElement] {
        var types = [type.jsonType]
        if let jsonRawValueType = type as? JSONRawValueType.Type {
            types += jsonRawValueType.extraJSONTypes
        }
        return types
    }
}
