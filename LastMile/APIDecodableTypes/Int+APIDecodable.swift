//
//  Int+APIDecodable.swift
//  LastMile
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension Int: APIDecodable {

    public init?(from decoder: APIDecoder) {
        guard let nsNumber = decoder.json as? NSNumber, !nsNumber.isBoolean, let int = Int(exactly: nsNumber) else {
            let error = APIDecodeError(path: decoder.nodePath, actual: decoder.node.jsonType)
            decoder.recordError(error)
            return nil
        }
        self = int
    }
}
