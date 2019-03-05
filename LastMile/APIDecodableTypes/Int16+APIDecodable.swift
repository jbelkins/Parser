//
//  Int16+APIDecodable.swift
//  LastMile
//
//  Created by Josh Elkins on 3/2/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation


extension Int16: APIDecodable {

    public init?(from decoder: APIDecoder) {
        guard let nsNumber = decoder.json as? NSNumber, !nsNumber.isBoolean, let int16 = Int16(exactly: nsNumber) else {
            let error = APIDecodeError(path: decoder.path, actual: decoder.key.jsonType)
            decoder.recordError(error)
            return nil
        }
        self = int16
    }
}
