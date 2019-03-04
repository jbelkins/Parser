//
//  DecodableStruct.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation
import LastMile


struct MainDecodableStruct: Equatable {
    let id: Int
    let name: String
    let subArray: [DecodableSubStruct]
    let null: NSNull
    let indexed: [String: DecodableSubStruct]
    let truthy: Bool
    let decodable: SwiftDecodableStruct

    let falsey: Bool?
    let decimal: Double?
    let description: String?
    var substruct: DecodableSubStruct?
}


extension MainDecodableStruct: APIDecodable {
    static let idKey: String? = "id"

    init?(from decoder: APIDecoder) {
        let id =          decoder["id"]            --> Int.self
        let name =        decoder["name"]          --> String.self
        let subArray =    decoder["substructs"]    --> CountLimited<[DecodableSubStruct]>(exactly: 2)
        let null =        decoder["null"]          --> NSNull.self
        let indexed =     decoder["indexed"]       --> [String: DecodableSubStruct].self
        let truthy =      decoder["truthy"]        --> Bool.self
        let decodable =   decoder["decodable"]     .decodeRequired(swiftDecodable: SwiftDecodableStruct.self)

        let falsey =      decoder["falsey"]        --> Bool?.self
        let decimal =     decoder["decimal"]       --> Double?.self
        let description = decoder["description"]   --> String?.self
        let substruct =   decoder["substruct"]     --> DecodableSubStruct?.self

        guard decoder.succeeded else { return nil }
        self.init(id: id!, name: name!, subArray: subArray!, null: null!, indexed: indexed!, truthy: truthy!, decodable: decodable!, falsey: falsey, decimal: decimal, description: description, substruct: substruct)
    }
}


func ==(lhs: MainDecodableStruct, rhs: MainDecodableStruct) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.description == rhs.description && lhs.substruct == rhs.substruct
}
