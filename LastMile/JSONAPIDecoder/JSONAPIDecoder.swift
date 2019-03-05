//
//  JSONAPIDecoder.swift
//  LastMile
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public class JSONAPIDecoder: APIDecoder {
    public var codingKey: CodingKey { return key }
    public var codingPath: [CodingKey] { return Array(path.dropFirst()) }
    public var key: APICodingKey
    public let json: Any?
    public var succeeded = true
    public let options: [String: Any]
    public var errors = [APIDecodeError]()
    let parent: JSONAPIDecoder?
    let errorTarget: JSONAPIDecoder?

    init(codingKey: CodingKey, json: Any?, parent: JSONAPIDecoder?, errorTarget: JSONAPIDecoder?, options: [String: Any]) {
        self.key = APICodingKey(codingKey: codingKey)
        self.key.jsonType = JSONElement.type(for: json)
        self.json = json
        self.parent = parent
        self.errorTarget = errorTarget
        self.options = options
    }

    // MARK: - Creating decoders for JSON sub-elements

    public subscript(key: String) -> APIDecoder {
        let codingKey = APICodingKey(stringValue: key)!
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return JSONAPIDecoder(codingKey: codingKey, json: newJSON, parent: self, errorTarget: self, options: options)
    }

    public subscript(index: Int) -> APIDecoder {
        let codingKey = APICodingKey(intValue: index)!
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return JSONAPIDecoder(codingKey: codingKey, json: newJSON, parent: self, errorTarget: self, options: options)
    }

    public subscript(codingKey: CodingKey) -> APIDecoder {
        let newJSON = JSONTools.traverseJSON(json: json, at: codingKey)
        return JSONAPIDecoder(codingKey: codingKey, json: newJSON, parent: self, errorTarget: self, options: options)
    }

    public func superDecoder() -> APIDecoder {
        return JSONAPIDecoder(codingKey: codingKey, json: json, parent: parent, errorTarget: self, options: options)
    }

    public func errorHoldingDecoder() -> APIDecoder {
        return JSONAPIDecoder(codingKey: codingKey, json: json, parent: parent, errorTarget: nil, options: options)
    }

    // MARK: - Decoding
    // MARK: APIDecodable

    public func decodeRequired<DecodedType: APIDecodable>(_ type: DecodedType.Type, min: Int?, max: Int?, countsAreMandatory: Bool) -> DecodedType! {
        let element = decode(type: type, required: true, min: min, max: max, countsAreMandatory: countsAreMandatory)
        if element == nil { swiftParent?.succeeded = false }
        return element
    }

    public func decodeOptional<DecodedType: APIDecodable>(_ type: DecodedType.Type, min: Int?, max: Int?, countsAreMandatory: Bool) -> DecodedType? {
        return decode(type: type, required: false, min: min, max: max, countsAreMandatory: countsAreMandatory)
    }

    // MARK: Swift Decodable

    public func decodeRequired<DecodedType: Decodable>(swiftDecodable type: DecodedType.Type) -> DecodedType! {
        guard let decodedValue = decode(swiftDecodable: DecodedType.self) else { succeeded = false; return nil }
        return decodedValue
    }

    public func decodeOptional<DecodedType: Decodable>(swiftDecodable type: DecodedType.Type) -> DecodedType? {
        return decode(swiftDecodable: DecodedType.self)
    }

    private func decode<DecodedType: Decodable>(swiftDecodable type: DecodedType.Type) -> DecodedType? {
        do {
            let swiftDecoder = SwiftAPIDecoder(decoder: self)
            return try DecodedType.init(from: swiftDecoder)
        } catch let swiftDecodingError as DecodingError {
            let decodeError = APIDecodeError(path: path, swiftDecodingError: swiftDecodingError)
            recordError(decodeError)
        } catch let decodeError as APIDecodeError {
            recordError(decodeError)
        } catch let error {
            let decodeError = APIDecodeError(path: path, message: error.localizedDescription)
            recordError(decodeError)
        }
        return nil
    }

    public func recordError(_ error: APIDecodeError) {
        guard let errorTarget = errorTarget else { errors.append(error); return }
        errorTarget.recordError(error)
    }

    // MARK: - Path retrieval

    public var path: [APICodingKey] {
        guard let parent = parent else { return [key] }
        return parent.path + [key]
    }

    public var swiftParent: JSONAPIDecoder? {
        guard let parent = parent else { return nil }
        guard parent.key.swiftType != nil else { return parent.swiftParent }
        return parent
    }

    // MARK: - Private methods

    private func decode<DecodedType: APIDecodable>(type: DecodedType.Type, required: Bool, min: Int?, max: Int?, countsAreMandatory: Bool) -> DecodedType? {
        tagKey(type: type)
        guard (json != nil && !(json is NSNull && type != NSNull.self)) || type == ResponseData.self else {
            if required {
                let error = APIDecodeError(path: path, actual: key.jsonType)
                recordError(error)
            }
            return nil
        }
        let parsed = DecodedType.init(from: self)
        if let count = parsed?.parseableElementCount {
            if let min = min, let max = max, min == max, min != count {
                recordError(APIDecodeError(path: path, expected: min, actual: count))
                if countsAreMandatory { return nil }
            } else if let min = min, count < min {
                recordError(APIDecodeError(path: path, minimum: min, actual: count))
                if countsAreMandatory { return nil }
            } else if let max = max, count > max {
                recordError(APIDecodeError(path: path, maximum: max, actual: count))
                if countsAreMandatory { return nil }
            }
        }
        return parsed
    }

    private func tagKey(type: APIDecodable.Type) {
        key.swiftType = key.swiftType ?? type
        key.idKey = key.idKey ?? type.idKey
        key.id = key.id ?? type.id(from: json)
    }
}
