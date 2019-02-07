//
//  DecodableStruct.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/12/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation
import Parser


struct DecodableStruct: Decodable, Equatable {
    let id: Int
    let name: String
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case notes
    }
}


extension DecodableStruct: Parseable {}
