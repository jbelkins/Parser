//
//  DecodableStruct.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/12/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation
import Parser


struct DecodableStruct: Decodable {
    let id: Int
    let name: String
    let notes: String?
}

extension DecodableStruct: Parseable {
    static let idKey: String? = nil
    static let jsonType: JSONElement = .object

}


func ==(lhs:DecodableStruct, rhs: DecodableStruct) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.notes == rhs.notes
}
