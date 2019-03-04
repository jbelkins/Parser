//
//  JSONAPIDecoder.swift
//  LastMile
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public class JSONAPIDecoder: APIDecoder {
    public var codingKey: CodingKey { return node }
    public var codingPath: [CodingKey] { return nodePath }
    public var node: DecodingPathNode
    public let json: Any?
    public var succeeded = true
    public let options: [String: Any]
    public var errors = [APIDecodeError]()
    let parent: JSONAPIDecoder?

    init(codingKey: CodingKey, json: Any?, parent: JSONAPIDecoder?, options: [String: Any]) {
        self.node = DecodingPathNode(codingKey: codingKey)
        self.node.castableJSONTypes = JSONElement.types(for: json)
        self.json = json
        self.parent = parent
        self.options = options
    }

    // MARK: - Creating parsers for JSON sub-elements

    public subscript(key: String) -> APIDecoder {
        let codingKey = DecodingPathNode(stringValue: key)!
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return JSONAPIDecoder(codingKey: codingKey, json: newJSON, parent: self, options: options)
    }

    public subscript(index: Int) -> APIDecoder {
        let codingKey = DecodingPathNode(intValue: index)!
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return JSONAPIDecoder(codingKey: codingKey, json: newJSON, parent: self, options: options)
    }

    public subscript(codingKey: CodingKey) -> APIDecoder {
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return JSONAPIDecoder(codingKey: codingKey, json: newJSON, parent: self, options: options)
    }

    public func superDecoder() -> APIDecoder {
        return JSONAPIDecoder(codingKey: codingKey, json: json, parent: self, options: options)
    }

    public func errorHoldingDecoder() -> APIDecoder {
        return JSONAPIDecoder(codingKey: codingKey, json: json, parent: nil, options: options)
    }

    // MARK: - Parsing

    public func decodeRequired<DecodedType: APIDecodable>(_ type: DecodedType.Type, min: Int?, max: Int?, countsAreMandatory: Bool) -> DecodedType! {
        let element = decode(type: type, required: true, min: min, max: max, countsAreMandatory: countsAreMandatory)
        if element == nil { swiftParent?.succeeded = false }
        return element
    }

    public func decodeOptional<DecodedType: APIDecodable>(_ type: DecodedType.Type, min: Int?, max: Int?, countsAreMandatory: Bool) -> DecodedType? {
        return decode(type: type, required: false, min: min, max: max, countsAreMandatory: countsAreMandatory)
    }

    public func decodeRequired<DecodedType: Decodable>(swiftDecodable type: DecodedType.Type) -> DecodedType! {
        do {
            let swiftDecoder = NodeParserDecoder(decoder: self)
            return try DecodedType.init(from: swiftDecoder)
        } catch let decodingError as DecodingError {
            let parseError = APIDecodeError(path: nodePath, decodingError: decodingError)
            recordError(parseError)
        } catch let error {
            let parseError = APIDecodeError(path: nodePath, message: error.localizedDescription)
            recordError(parseError)
        }
        succeeded = false
        return nil
    }

    public func decodeOptional<DecodedType: Decodable>(swiftDecodable type: DecodedType.Type) -> DecodedType? {
        do {
            let swiftDecoder = NodeParserDecoder(decoder: self)
            return try DecodedType.init(from: swiftDecoder)
        } catch let decodingError as DecodingError {
            let parseError = APIDecodeError(path: nodePath, decodingError: decodingError)
            recordError(parseError)
        } catch let error {
            let parseError = APIDecodeError(path: nodePath, message: error.localizedDescription)
            recordError(parseError)
        }
        return nil
    }

    public func recordError(_ error: APIDecodeError) {
        guard let parent = parent else { errors.append(error); return }
        parent.recordError(error)
    }

    // MARK: - Path retrieval

    public var nodePath: [DecodingPathNode] {
        guard let parent = parent else { return [node] }
        return parent.nodePath + [node]
    }

    public var swiftParent: JSONAPIDecoder? {
        guard let parent = parent else { return nil }
        guard parent.node.swiftType != nil else { return parent.swiftParent }
        return parent
    }

    // MARK: - Private methods

    private func decode<DecodedType: APIDecodable>(type: DecodedType.Type, required: Bool, min: Int?, max: Int?, countsAreMandatory: Bool) -> DecodedType? {
        tagNode(type: type)
        guard (json != nil && !(json is NSNull && type != NSNull.self)) || type == ResponseData.self else {
            if required {
                let error = APIDecodeError(path: nodePath, actual: node.castableJSONTypes)
                recordError(error)
            }
            return nil
        }
        let parsed = DecodedType.init(from: self)
        if let count = parsed?.parseableElementCount {
            if let min = min, let max = max, min == max, min != count {
                recordError(APIDecodeError(path: nodePath, expected: min, actual: count))
                if countsAreMandatory { return nil }
            } else if let min = min, count < min {
                recordError(APIDecodeError(path: nodePath, minimum: min, actual: count))
                if countsAreMandatory { return nil }
            } else if let max = max, count > max {
                recordError(APIDecodeError(path: nodePath, maximum: max, actual: count))
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
