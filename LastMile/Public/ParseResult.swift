//
//  DecodeResult.swift
//  LastMile
//
//  Created by Josh Elkins on 2/27/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation


public struct DecodeResult<ParsedValue: APIDecodable> {
    public let value: ParsedValue?
    public let errors: [ParseError]
}
