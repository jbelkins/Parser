//
//  DecodableSubStruct.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation
import LastMile


struct DecodableSubStruct: Equatable {
    let identifier: String
}


extension DecodableSubStruct: APIDecodable {
    static var idKey: String? = "identifier"

    init?(from decoder: APIDecoder) {
        let identifier = decoder["identifier"] --> String.self
        guard decoder.succeeded else { return nil }
        self.init(identifier: identifier!)
    }
}


func ==(lhs: DecodableSubStruct, rhs: DecodableSubStruct) -> Bool {
    return lhs.identifier == rhs.identifier
}
