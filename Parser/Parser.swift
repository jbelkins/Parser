//
//  Parser.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


protocol Parseable {
    static var idKey: String? { get }

    init?(parser: inout Parser)
}


extension Parseable {

    static func id(from json: Any?) -> String? {
        guard let idKey = idKey, let jsonDictionary = json as? [String: Any] else { return nil }
        if let int = jsonDictionary[idKey] as? Int {
            return String(describing: int)
        } else if let string = jsonDictionary[idKey] as? String {
            return string
        }
        return nil
    }
}


struct Parser {
    var path: [PathNode]
    let json: Any?
    var errors: [ParseError]
    var hasRequiredFields = false
    var failureWasChecked = false
    private var _succeeded = true

    init(data: Data) throws {
        let bareJSON = try JSONSerialization.jsonObject(with: data, options: [])
        let json = ["root": bareJSON]
        self.init(json: json, path: [], adding: [])
    }

    init(json: Any?, path: [PathNode], adding newNodes: [PathNode]) {
        self.json = Parser.traverseJSON(json: json, across: newNodes)
        self.path = path + newNodes
        self.errors = []
    }

    mutating func parse<RootElement: Parseable>(rootType: RootElement.Type) -> RootElement? {
        let rootNode = PathNode(jsonKey: "root", swiftType: RootElement.self)
        return parse(type: rootType, at: [rootNode], required: true)
    }

    mutating func parseRequired<InnerElement: Parseable>(type: InnerElement.Type, atKey key: String) -> InnerElement! {
        let newNodes = [PathNode(jsonKey: key, swiftType: InnerElement.self)]
        return parseRequired(type: InnerElement.self, at: newNodes)
    }

    mutating func parseRequired<InnerElement: Parseable>(type: InnerElement.Type, at localNodes: [PathNode]) -> InnerElement! {
        let element = parse(type: type, at: localNodes, required: true)
        if element == nil { _succeeded = false }
        hasRequiredFields = true
        return element
    }

    mutating func parseOptional<InnerElement: Parseable>(type: InnerElement.Type, atKey key: String) -> InnerElement? {
        let newNodes = [PathNode(jsonKey: key, swiftType: InnerElement.self)]
        return parse(type: InnerElement.self, at: newNodes, required: false)
    }

    mutating private func parse<InnerElement: Parseable>(type: InnerElement.Type, at localNodes: [PathNode], required: Bool) -> InnerElement? {
        var localParser = Parser(json: json, path: path, adding: localNodes)
        localParser.tag(type: InnerElement.self)
        let element: InnerElement?
        if localParser.json == nil {
            element = nil
            if required {
                let error = ParseError(path: localParser.path, message: "Missing \(InnerElement.self)")
                errors.append(error)
            }
        } else {
            element = InnerElement.init(parser: &localParser)
            errors.append(contentsOf: localParser.errors)
        }
        if !localParser.failureWasChecked && localParser.hasRequiredFields {
            fatalError("Failure was not checked when parsing \(InnerElement.self)")
        }
        return element
    }

    mutating func tag(type: Parseable.Type) {
        if var lastNode = path.last, let lastIndex = path.indices.last {
            lastNode.idKey = type.idKey
            lastNode.id = type.id(from: json)
            path[lastIndex] = lastNode
        }
    }

    mutating func succeeded() -> Bool {
        failureWasChecked = true
        return _succeeded
    }

    private static func traverseJSON(json: Any?, across nodes: [PathNode]) -> Any? {
        var localJSON = json
        for node in nodes {
            guard let localJSONDict = localJSON as? [String: Any] else { break }
            localJSON = localJSONDict[node.jsonKey]
        }
        return localJSON
    }
}
