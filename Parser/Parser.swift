//
//  Parser.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public class Parser {
    var node: PathNode
    let json: Any?
    let isRequired: Bool
    public var succeeded = true
    var errors = [ParseError]()
    let parent: Parser?

    init(node: PathNode, json: Any?, isRequired: Bool, parent: Parser?) {
        self.node = node
        self.node.jsonType = JSONElement(json: json)
        self.json = json
        self.isRequired = isRequired
        self.parent = parent
    }

    // MARK: - Creating parsers for JSON sub-elements

    public subscript(key: String) -> Parser {
        let newNode = PathNode(hashKey: key, swiftType: nil)
        let newJSON = Parser.traverseJSON(json: json, at: newNode)
        return Parser(node: newNode, json: newJSON, isRequired: isRequired, parent: self)
    }

    public subscript(index: Int) -> Parser {
        let newNode = PathNode(arrayIndex: index, swiftType: nil)
        let newJSON = Parser.traverseJSON(json: json, at: newNode)
        return Parser(node: newNode, json: newJSON, isRequired: isRequired, parent: self)
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

    // MARK: - ErrorTarget protocol

    func recordError(_ error: ParseError) {
        if let parent = parent {
            parent.recordError(error)
        } else {
            errors.append(error)
        }
    }

    // MARK: - Path retrieval

    var path: [PathNode] {
        if let parent = parent {
            return parent.path + [node]
        } else {
            return [node]
        }
    }

    var swiftParent: Parser? {
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

    private func parse<ParsedType: Parseable>(type parsedType: ParsedType.Type, required: Bool) -> ParsedType? {
        tagNode(type: parsedType)
        let element: ParsedType?
        if node.jsonType == parsedType.jsonType || (node.jsonType == .int && parsedType.jsonType == .double) {
            element = ParsedType.init(parser: self)
        } else {
            element = nil
            if required {
                let description = json != nil ? "\(node.jsonType.rawValue)" : "nil"
                let error = ParseError(path: path, message: "Expected JSON \(ParsedType.jsonType.rawValue), got \(description)")
                recordError(error)
            }
        }
        return element
    }

    private func tagNode(type: Parseable.Type) {
        node.swiftType = type
        node.idKey = type.idKey
        node.id = type.id(from: json)
    }

    private static func traverseJSON(json: Any?, at node: PathNode) -> Any? {
        var localJSON = json
        if let hashKey = node.hashKey {
            guard let localJSONDict = localJSON as? [String: Any] else { return nil }
            localJSON = localJSONDict[hashKey]
        } else if let arrayIndex = node.arrayIndex {
            guard let localJSONArray = localJSON as? [Any] else { return nil }
            guard arrayIndex < localJSONArray.count else { return nil }
            localJSON = localJSONArray[arrayIndex]
        }
        return localJSON
    }
}
