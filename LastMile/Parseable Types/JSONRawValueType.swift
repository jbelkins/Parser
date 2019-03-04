//
//  JSONRawValueType.swift
//  LastMile
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


protocol JSONRawValueType: APIDecodable {}


extension JSONRawValueType {

    public init?(from decoder: APIDecoder) {
        guard let value = decoder.json as? Self else {
            let error = ParseError(path: decoder.nodePath, actual: decoder.node.castableJSONTypes)
            decoder.recordError(error)
            return nil
        }
        self = value
    }
}
