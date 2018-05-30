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

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case notes
    }

    init(id: Int, name: String, notes: String?) {
        self.id = id
        self.name = name
        self.notes = notes
    }

    init?(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
    }
}

extension DecodableStruct: Parseable {
    static let idKey: String? = nil
    static let jsonType: JSONElement = .object

}


func ==(lhs: DecodableStruct, rhs: DecodableStruct) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.notes == rhs.notes
}
