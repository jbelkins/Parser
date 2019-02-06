//
//  ObjectDecoder.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation


public struct ObjectDecoder {

    public init() {}

    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        let decoder = _ObjectDecoder(jsonObject: jsonObject)
        return try T(from: decoder)
    }
}
