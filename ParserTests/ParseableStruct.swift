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
    let subArray: [ParseableSubStruct]
    let null: NSNull
    let indexed: [String: ParseableSubStruct]
    let truthy: Bool

    let falsey: Bool?
    let decimal: Double?
    let description: String?
    var substruct: ParseableSubStruct?
}


extension ParseableStruct: Parseable {
    static let idKey: String? = "id"
    static let jsonType: JSONElement = .object

    init?(parser: Parser) {
        let id =          parser["id"]            --> Create<Int>()
        let name =        parser["name"]          --> String.self
        let subArray =    parser["substructs"]    --> Create<[ParseableSubStruct]>(exactly: 2)
        let null =        parser["null"]          --> NSNull.self
        let indexed =     parser["indexed"]       --> [String: ParseableSubStruct].self
        let truthy =      parser["truthy"]        --> Bool.self

        let falsey =      parser["falsey"]        --> Create<Bool?>()
        let decimal =     parser["decimal"]       --> Double?.self
        let description = parser["description"]   --> String?.self
        let substruct =   parser["substruct"]     --> ParseableSubStruct?.self

        guard parser.succeeded else { return nil }
        self.init(id: id!, name: name!, subArray: subArray!, null: null!, indexed: indexed!, truthy: truthy!, falsey: falsey, decimal: decimal, description: description, substruct: substruct)
    }
}


func ==(lhs: ParseableStruct, rhs: ParseableStruct) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.description == rhs.description && lhs.substruct == rhs.substruct
}
