//
//  Parser.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


open class Parser: ErrorTarget {
    var path: [PathNode]
    let json: Any?
    let isRequired: Bool
    public var succeeded = true {
        didSet { succeededTarget?.succeeded = succeeded }
    }
    weak var succeededTarget: Parser?
    weak var errorTarget: ErrorTarget?

    init(path: [PathNode], json: Any?, isRequired: Bool, errorTarget: ErrorTarget? = nil, succeededTarget: Parser? = nil) {
        self.path = path
        self.json = json
        self.isRequired = isRequired
        self.errorTarget = errorTarget
        self.succeededTarget = succeededTarget
    }

    // MARK: - Creating parsers for JSON sub-elements

    public subscript(key: String) -> Parser {
        let newNode = PathNode(hashKey: key, swiftType: nil)
        let newJSON = Parser.traverseJSON(json: json, across: [newNode])
        return Parser(path: path + [newNode], json: newJSON, isRequired: isRequired, errorTarget: self, succeededTarget: self)
    }

    public subscript(index: Int) -> Parser {
        let newNode = PathNode(arrayIndex: index, swiftType: nil)
        let newJSON = Parser.traverseJSON(json: json, across: [newNode])
        return Parser(path: path + [newNode], json: newJSON, isRequired: isRequired, errorTarget: self, succeededTarget: self)
    }

    // MARK: - Parsing

    public func required<ParsedType: Parseable>(_ type: ParsedType.Type) -> ParsedType! {
        let element = parse(type: type, required: true)
        if element == nil { succeeded = false }
        return element
    }

    public func optional<ParsedType: Parseable>(_ type: ParsedType.Type) -> ParsedType? {
        return parse(type: ParsedType.self, required: false)
    }

    public func addError(_ error: ParseError) {
        errorTarget?.receiveErrors([error])
    }

    // MARK: - ErrorTarget protocol

    func receiveErrors(_ receivedErrors: [ParseError]) {
        errorTarget?.receiveErrors(receivedErrors)
    }

    // MARK: - Private methods

    private func parse<ParsedType: Parseable>(type: ParsedType.Type, required: Bool) -> ParsedType? {
        tag(type: ParsedType.self)
        let element: ParsedType?
        if json == nil {
            element = nil
            if required {
                let error = ParseError(path: path, message: "Missing \(ParsedType.self)")
                errorTarget?.receiveErrors([error])
            }
        } else {
            element = ParsedType.init(parser: self)
        }
        return element
    }

    private func tag(type: Parseable.Type) {
        if var lastNode = path.last, let lastIndex = path.indices.last {
            lastNode.idKey = type.idKey
            lastNode.id = type.id(from: json)
            path[lastIndex] = lastNode
        }
    }

    private static func traverseJSON(json: Any?, across nodes: [PathNode]) -> Any? {
        var localJSON = json
        for node in nodes {
            if let hashKey = node.hashKey {
                guard let localJSONDict = localJSON as? [String: Any] else { localJSON = nil; break }
                localJSON = localJSONDict[hashKey]
            } else if let arrayIndex = node.arrayIndex {
                guard let localJSONArray = localJSON as? [Any] else { localJSON = nil; break }
                guard arrayIndex < localJSONArray.count else { localJSON = nil; break }
                localJSON = localJSONArray[arrayIndex]
            }
        }
        return localJSON
    }
}
