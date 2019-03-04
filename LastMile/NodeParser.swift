//
//  NodeParser.swift
//  LastMile
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public class NodeParser: APIDecoder {
    public var codingKey: CodingKey { return node }
    public var codingPath: [CodingKey] { return nodePath }
    public var node: PathNode
    public let json: Any?
    public var succeeded = true
    public let options: [String: Any]
    public var errors = [ParseError]()
    let parent: NodeParser?

    init(codingKey: CodingKey, json: Any?, parent: NodeParser?, options: [String: Any]) {
        self.node = PathNode(codingKey: codingKey)
        self.node.castableJSONTypes = JSONElement.types(for: json)
        self.json = json
        self.parent = parent
        self.options = options
    }

    // MARK: - Creating parsers for JSON sub-elements

    public subscript(key: String) -> APIDecoder {
        let codingKey = PathNode(stringValue: key)!
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return NodeParser(codingKey: codingKey, json: newJSON, parent: self, options: options)
    }

    public subscript(index: Int) -> APIDecoder {
        let codingKey = PathNode(intValue: index)!
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return NodeParser(codingKey: codingKey, json: newJSON, parent: self, options: options)
    }

    public subscript(codingKey: CodingKey) -> APIDecoder {
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return NodeParser(codingKey: codingKey, json: newJSON, parent: self, options: options)
    }

    public func superParser() -> APIDecoder {
        return NodeParser(codingKey: codingKey, json: json, parent: self, options: options)
    }

    public func errorHoldingParser() -> APIDecoder {
        return NodeParser(codingKey: codingKey, json: json, parent: nil, options: options)
    }

    // MARK: - Parsing

    public func required<DecodedType: APIDecodable>(_ type: DecodedType.Type, min: Int?, max: Int?, countsAreMandatory: Bool) -> DecodedType! {
        let element = parse(type: type, required: true, min: min, max: max, countsAreMandatory: countsAreMandatory)
        if element == nil { swiftParent?.succeeded = false }
        return element
    }

    public func optional<DecodedType: APIDecodable>(_ type: DecodedType.Type, min: Int?, max: Int?, countsAreMandatory: Bool) -> DecodedType? {
        return parse(type: type, required: false, min: min, max: max, countsAreMandatory: countsAreMandatory)
    }

    public func decode<DecodedType: Decodable>(_ type: DecodedType.Type) -> DecodedType! {
        do {
            let swiftDecoder = NodeParserDecoder(decoder: self)
            return try DecodedType.init(from: swiftDecoder)
        } catch let decodingError as DecodingError {
            let parseError = ParseError(path: nodePath, decodingError: decodingError)
            recordError(parseError)
        } catch let error {
            let parseError = ParseError(path: nodePath, message: error.localizedDescription)
            recordError(parseError)
        }
        succeeded = false
        return nil
    }

    public func decodeIfPresent<DecodedType: Decodable>(_ type: DecodedType.Type) -> DecodedType? {
        do {
            let swiftDecoder = NodeParserDecoder(decoder: self)
            return try DecodedType.init(from: swiftDecoder)
        } catch let decodingError as DecodingError {
            let parseError = ParseError(path: nodePath, decodingError: decodingError)
            recordError(parseError)
        } catch let error {
            let parseError = ParseError(path: nodePath, message: error.localizedDescription)
            recordError(parseError)
        }
        return nil
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

    public var swiftParent: NodeParser? {
        guard let parent = parent else { return nil }
        guard parent.node.swiftType != nil else { return parent.swiftParent }
        return parent
    }

    // MARK: - Private methods

    private func parse<DecodedType: APIDecodable>(type: DecodedType.Type, required: Bool, min: Int?, max: Int?, countsAreMandatory: Bool) -> DecodedType? {
        tagNode(type: type)
        guard (json != nil && !(json is NSNull && type != NSNull.self)) || type == ResponseData.self else {
            if required {
                let error = ParseError(path: nodePath, actual: node.castableJSONTypes)
                recordError(error)
            }
            return nil
        }
        let parsed = DecodedType.init(from: self)
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

    private func tagNode(type: APIDecodable.Type) {
        node.swiftType = type
        node.idKey = type.idKey
        node.id = type.id(from: json)
    }
}
