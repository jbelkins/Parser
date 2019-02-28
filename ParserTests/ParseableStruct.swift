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
    let decodable: DecodableStruct

    let falsey: Bool?
    let decimal: Double?
    let description: String?
    var substruct: ParseableSubStruct?
}


extension ParseableStruct: Parseable {
    static let idKey: String? = "id"
    static var jsonTypes: Set<JSONElement> { return [.object] }

    init?(parser: Parser) {
        let id =          parser["id"]            --> Int.self
        let name =        parser["name"]          --> String.self
        let subArray =    parser["substructs"]    --> CountLimited<[ParseableSubStruct]>(exactly: 2)
        let null =        parser["null"]          --> NSNull.self
        let indexed =     parser["indexed"]       --> [String: ParseableSubStruct].self
        let truthy =      parser["truthy"]        --> Bool.self
        let decodable =   parser["decodable"]     --> DecodableStruct.self

        let falsey =      parser["falsey"]        --> Bool?.self
        let decimal =     parser["decimal"]       --> Double?.self
        let description = parser["description"]   --> String?.self
        let substruct =   parser["substruct"]     --> ParseableSubStruct?.self

        guard parser.succeeded else { return nil }
        self.init(id: id!, name: name!, subArray: subArray!, null: null!, indexed: indexed!, truthy: truthy!, decodable: decodable!, falsey: falsey, decimal: decimal, description: description, substruct: substruct)
    }
}


func ==(lhs: ParseableStruct, rhs: ParseableStruct) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.description == rhs.description && lhs.substruct == rhs.substruct
}
