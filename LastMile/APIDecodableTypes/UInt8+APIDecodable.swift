//
//  UInt8+APIDecodable.swift
//  LastMile
//
//  Created by Josh Elkins on 3/2/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation


extension UInt8: APIDecodable {

    public init?(from decoder: APIDecoder) {
        guard let nsNumber = decoder.json as? NSNumber, let uint8 = UInt8(exactly: nsNumber) else {
            let error = APIDecodeError(path: decoder.nodePath, actual: decoder.node.jsonType)
            decoder.recordError(error)
            return nil
        }
        self = uint8
    }
}
