//
//  APIDecoder.swift
//  LastMile
//
//  Created by Josh Elkins on 2/10/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public protocol APIDecoder: class {
    var json: Any? { get }
    var codingKey: CodingKey { get }
    var codingPath: [CodingKey] { get }
    var node: PathNode { get }
    var nodePath: [PathNode] { get }
    subscript(key: String) -> APIDecoder { get }
    subscript(index: Int) -> APIDecoder { get }
    subscript(codingKey: CodingKey) -> APIDecoder { get }
    func superParser() -> APIDecoder
    func errorHoldingParser() -> APIDecoder
    func required<DecodedType: APIDecodable>(_ type: DecodedType.Type, min: Int?, max: Int?, countsAreMandatory: Bool) -> DecodedType!
    func optional<DecodedType: APIDecodable>(_ type: DecodedType.Type, min: Int?, max: Int?, countsAreMandatory: Bool) -> DecodedType?
    func decode<DecodedType: Swift.Decodable>(_ type: DecodedType.Type) -> DecodedType!
    func decodeIfPresent<DecodedType: Swift.Decodable>(_ type: DecodedType.Type) -> DecodedType?
    func recordError(_ error: ParseError)
    var succeeded: Bool { get set }
    var options: [String: Any] { get }
}


public extension APIDecoder {

    func required<DecodedType: APIDecodable>(_ type: DecodedType.Type, min: Int? = nil, max: Int? = nil, countsAreMandatory: Bool = false) -> DecodedType! {
        return required(type, min: min, max: max, countsAreMandatory: countsAreMandatory)
    }

    func optional<DecodedType: APIDecodable>(_ type: DecodedType.Type, min: Int? = nil, max: Int? = nil, countsAreMandatory: Bool = false) -> DecodedType? {
        return optional(type, min: min, max: max,  countsAreMandatory: countsAreMandatory)
    }
}


public enum ParserOptions {
    public static let rootNodeNameKey = "ParserOptions.rootNodeNameKey"
    public static let rawDataKey = "ParserOptions.rawDataKey"
}
