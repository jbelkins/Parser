//
//  APIDataDecoder.swift
//  LastMile
//
//  Created by Josh Elkins on 2/7/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public class APIDataDecoder {

    public init() {}

    public func decode<DecodedType: APIDecodable>(data: Data?, to type: DecodedType.Type, options: [String: Any] = [:]) -> DecodeResult<DecodedType> {
        let newData = data ?? Data()
        var newOptions = options
        newOptions[APIDecodeOptions.rawDataKey] = newData
        let json: Any? = try? JSONSerialization.jsonObject(with: newData, options: [])
        return APIJSONObjectDecoder().decode(json: json, to: DecodedType.self, options: newOptions)
    }
}
