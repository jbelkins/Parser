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
        guard let nsNumber = decoder.json as? NSNumber, !nsNumber.isBoolean else {
            let error = APIDecodeError(path: decoder.path, actual: decoder.key.jsonType)
            decoder.recordError(error)
            return nil
        }
        guard let int = Int(exactly: nsNumber) else {
            let error = APIDecodeError(path: decoder.path, value: "\(nsNumber)", impreciseType: "\(Int.self)")
            decoder.recordError(error)
            return nil
        }
        self = int
    }
}


extension NSNumber {
    var isIntegral: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
