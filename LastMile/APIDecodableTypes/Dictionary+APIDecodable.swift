//
//  Dictionary+APIDecodable.swift
//  LastMile
//
//  Created by Josh Elkins on 5/30/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension Dictionary: APIDecodable where Key == String, Value: APIDecodable {
    public var parseableElementCount: Int? { return count }

    public init?(from decoder: APIDecoder) {
        guard let jsonDict = decoder.json as? [String: Any] else {
            let error = APIDecodeError(path: decoder.nodePath, actual: decoder.node.jsonType)
            decoder.recordError(error)
            return nil
        }
        let parsed: [(String, Value)?] = jsonDict.map { (key, json) -> (String, Value)? in
            guard let value = decoder[key].decodeRequired(Value.self) else { return nil }
            return (key, value)
        }
        self = Dictionary(uniqueKeysWithValues: parsed.compactMap { $0 })
    }
}
