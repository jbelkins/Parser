//
//  DecodeResult.swift
//  LastMile
//
//  Created by Josh Elkins on 2/27/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation


public struct DecodeResult<DecodedValue: APIDecodable> {
    public let value: DecodedValue?
    public let errors: [APIDecodeError]
}
