//
//  ResponseData.swift
//  LastMile
//
//  Created by Josh Elkins on 3/1/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation


public struct ResponseData: APIDecodable {
    public static var alwaysSucceeds: Bool { return true }
    public let data: Data?

    public init?(from decoder: APIDecoder) {
        self.data = decoder.options[APIDecodeOptions.rawDataKey] as? Data
    }
}
