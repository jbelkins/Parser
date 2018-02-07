//
//  ParseableStruct.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation
import Parser


struct ParseableStruct: Equatable {
    let id: Int
    let name: String
    let first: ParseableSubStruct

    let optionalDescription: String?
    var substruct: ParseableSubStruct?
}


extension ParseableStruct: Parseable {
    static var idKey: String? = "id"

    init?(parser: Parser) {
        let id = parser["id"].required(Int.self)
        let name = parser["name"].required(String.self)
        let first = parser["substructs"][0].required(ParseableSubStruct.self)
        let optionalDescription = parser["description"].optional(String.self)
        let substruct = parser["substruct"].optional(ParseableSubStruct.self)
        guard parser.succeeded else { return nil }
        self.init(id: id!, name: name!, first: first!, optionalDescription: optionalDescription, substruct: substruct)
    }
}


func ==(lhs: ParseableStruct, rhs: ParseableStruct) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.optionalDescription == rhs.optionalDescription && lhs.substruct == rhs.substruct
}
