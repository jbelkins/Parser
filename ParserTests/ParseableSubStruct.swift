//
//  ParseableSubStruct.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation
import Parser


struct ParseableSubStruct: Equatable {
    let identifier: String
}


extension ParseableSubStruct: Parseable {
    static var idKey: String? = "identifier"
    static let jsonTypes = [JSONElement.object]

    init?(parser: Parser) {
        let identifier = parser["identifier"] --> String.self
        guard parser.succeeded else { return nil }
        self.init(identifier: identifier!)
    }
}


func ==(lhs: ParseableSubStruct, rhs: ParseableSubStruct) -> Bool {
    return lhs.identifier == rhs.identifier
}
