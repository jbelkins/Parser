//
//  RawRepresentable+APIDecodable.swift
//  LastMile
//
//  Created by Josh Elkins on 2/28/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation


extension RawRepresentable where RawValue: APIDecodable {

    public init?(from decoder: APIDecoder) {
        guard let rawValue = decoder --> RawValue.self else { return nil }
        guard let value = Self.init(rawValue: rawValue) else {
            let error = APIDecodeError(path: decoder.path, rawValue: "\(rawValue)", type: "\(Self.self)")
            decoder.recordError(error)
            return nil
        }
        self = value
    }
}
