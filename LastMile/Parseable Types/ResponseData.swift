//
//  ResponseData.swift
//  LastMile
//
//  Created by Josh Elkins on 3/1/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation


public struct ResponseData: APIDecodable {
    public let data: Data?

    public init?(from decoder: APIDecoder) {
        self.data = decoder.options[ParserOptions.rawDataKey] as? Data
    }
}
