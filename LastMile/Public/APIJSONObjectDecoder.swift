//
//  APIJSONObjectDecoder.swift
//  LastMile
//
//  Created by Josh Elkins on 2/12/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public class APIJSONObjectDecoder {

    public init() {}

    public func decode<DecodedType: APIDecodable>(json: Any?, to type: DecodedType.Type, options: [String: Any] = [:]) -> APIDecodeResult<DecodedType> {
        let decoder = APIJSONObjectDecoder.rootDecoder(json: json, options: options)
        let result = decoder.decodeRequired(DecodedType.self, min: nil, max: nil)
        return APIDecodeResult(value: result, errors: decoder.errors)
    }

    private static func rootDecoder(json: Any?, options: [String: Any]) -> JSONAPIDecoder {
        let rootNodeName = options[APIDecodeOptions.rootNodeNameKey] as? String ?? "root"
        let rootNode = APICodingKey(hashKey: rootNodeName, swiftType: nil)
        return JSONAPIDecoder(codingKey: rootNode, json: json, parent: nil, holdsErrors: true, options: options)
    }
}
