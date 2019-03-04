//
//  Bool+Decodable.swift
//  LastMile
//
//  Created by Josh Elkins on 2/11/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension Bool: APIDecodable {
    
    public init?(from decoder: APIDecoder) {
        guard let nsNumber = decoder.json as? NSNumber, nsNumber.isBoolean else {
            let error = APIDecodeError(path: decoder.nodePath, actual: decoder.node.castableJSONTypes)
            decoder.recordError(error)
            return nil
        }
        self = nsNumber.boolValue
    }
}


extension NSNumber {
    var isBoolean: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
