//
//  ParseableSubStruct.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation
@testable import Parser


struct ParseableSubStruct: Equatable {
    static var idKey: String? = "identifier"

    let identifier: String
}

extension ParseableSubStruct: Parseable {

    init?(parser: inout Parser) {
        let identifier = parser.parseRequired(type: String.self, atKey: "identifier")
        guard parser.succeeded() else { return nil }
        self.init(identifier: identifier!)
    }
}


func ==(lhs: ParseableSubStruct, rhs: ParseableSubStruct) -> Bool {
    return lhs.identifier == rhs.identifier
}
