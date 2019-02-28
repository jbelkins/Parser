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
}


extension DecodableStruct: Parseable {
    static var idKey: String? { return "id" }
    static var jsonTypes: Set<JSONElement> { return [.object] }
}
