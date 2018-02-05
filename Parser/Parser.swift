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


struct Parser {
    var path: [PathNode]
    let json: Any?
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
    }

    mutating func parse<RootElement: Parseable>(rootType: RootElement.Type) -> RootElement? {
        let rootNode = PathNode(jsonKey: "root", swiftType: RootElement.self)
        guard let element = parseRequired(type: rootType, at: [rootNode]) else { return nil }
        return element
    }

    mutating func parseRequired<InnerElement: Parseable>(type: InnerElement.Type, atKey key: String) -> InnerElement! {
        let newNodes = [PathNode(jsonKey: key, swiftType: InnerElement.self)]
        return parseRequired(type: InnerElement.self, at: newNodes)
    }

    mutating func parseRequired<InnerElement: Parseable>(type: InnerElement.Type, at localNodes: [PathNode]) -> InnerElement! {
        let element = parseOptional(type: type, at: localNodes)
        if element == nil { _succeeded = false }
        hasRequiredFields = true
        return element
    }

    mutating func parseOptional<InnerElement: Parseable>(type: InnerElement.Type, atKey key: String) -> InnerElement? {
        let newNodes = [PathNode(jsonKey: key, swiftType: InnerElement.self)]
        return parseOptional(type: InnerElement.self, at: newNodes)
    }

    mutating func parseOptional<InnerElement: Parseable>(type: InnerElement.Type, at localNodes: [PathNode]) -> InnerElement? {
        var localParser = Parser(json: json, path: path, adding: localNodes)
        let element = InnerElement.init(parser: &localParser)
        if !localParser.failureWasChecked && localParser.hasRequiredFields {
            fatalError("Failure was not checked when parsing \(InnerElement.self)")
        }
        return element
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
