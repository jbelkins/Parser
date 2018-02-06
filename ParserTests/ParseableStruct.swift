//
//  ParseableStruct.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation
@testable import Parser


struct ParseableStruct: Equatable {
    let id: Int
    let name: String
    let optionalDescription: String?
    var substruct: ParseableSubStruct?
}


extension ParseableStruct: Parseable {
    static var idKey: String? = "id"

    init?(parser: inout Parser) {
        let id = parser.parseRequired(type: Int.self, atKey: "id")
        let name = parser.parseRequired(type: String.self, atKey: "name")
        let optionalDescription = parser.parseOptional(type: String.self, atKey: "description")
        let substruct = parser.parseOptional(type: ParseableSubStruct.self, atKey: "substruct")
        guard parser.succeeded() else { return nil }
        self.init(id: id!, name: name!, optionalDescription: optionalDescription, substruct: substruct)
    }
}


func ==(lhs: ParseableStruct, rhs: ParseableStruct) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.optionalDescription == rhs.optionalDescription && lhs.substruct == rhs.substruct
}
