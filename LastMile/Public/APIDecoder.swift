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
    var key: APICodingKey { get }
    var path: [APICodingKey] { get }
    var errors: [APIDecodeError] { get set }
    subscript(key: String) -> APIDecoder { get }
    subscript(index: Int) -> APIDecoder { get }
    subscript(codingKey: CodingKey) -> APIDecoder { get }
    func superDecoder() -> APIDecoder
    func errorHoldingDecoder() -> APIDecoder
    func decodeRequired<DecodedType: APIDecodable>(_ type: DecodedType.Type, min: Int?, max: Int?, countsAreMandatory: Bool) -> DecodedType!
    func decodeOptional<DecodedType: APIDecodable>(_ type: DecodedType.Type, min: Int?, max: Int?, countsAreMandatory: Bool) -> DecodedType?
    func decodeRequired<DecodedType: Decodable>(swiftDecodable type: DecodedType.Type) -> DecodedType!
    func decodeOptional<DecodedType: Decodable>(swiftDecodable type: DecodedType.Type) -> DecodedType?
    func recordError(_ error: APIDecodeError)
    var succeeded: Bool { get set }
    var options: [String: Any] { get }
}


public extension APIDecoder {

    func decodeRequired<DecodedType: APIDecodable>(_ type: DecodedType.Type, min: Int? = nil, max: Int? = nil, countsAreMandatory: Bool = false) -> DecodedType! {
        return decodeRequired(type, min: min, max: max, countsAreMandatory: countsAreMandatory)
    }

    func decodeOptional<DecodedType: APIDecodable>(_ type: DecodedType.Type, min: Int? = nil, max: Int? = nil, countsAreMandatory: Bool = false) -> DecodedType? {
        return decodeOptional(type, min: min, max: max,  countsAreMandatory: countsAreMandatory)
    }
}


public enum APIDecodeOptions {
    public static let rootNodeNameKey = "APIDecodeOptions.rootNodeNameKey"
    public static let rawDataKey = "APIDecodeOptions.rawDataKey"
}
