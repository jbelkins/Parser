//
//  DataParser.swift
//  LastMile
//
//  Created by Josh Elkins on 2/7/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public class DataParser {

    public init() {}

    public func parse<DecodedType: APIDecodable>(data: Data?, to type: DecodedType.Type, options: [String: Any] = [:]) -> DecodeResult<DecodedType> {
        let newData = data ?? Data()
        var newOptions = options
        newOptions[ParserOptions.rawDataKey] = newData
        let json: Any? = try? JSONSerialization.jsonObject(with: newData, options: [])
        return JSONParser().parse(json: json, to: DecodedType.self, options: newOptions)
    }
}
