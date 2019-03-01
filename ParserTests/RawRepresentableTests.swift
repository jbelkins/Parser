//
//  RawRepresentableTests.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/28/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import XCTest
import Parser


enum Stooge: String, Parseable {
    case larry
    case curly
    case moe
    case shep
    case joe
}


struct StoogeStruct: Equatable {
    let stooge1: Stooge
    let stooge2: Stooge?
}


extension StoogeStruct: Parseable {

    init?(parser: Parser) {
        let stooge1 = parser["stooge1"] --> Stooge.self
        let stooge2 = parser["stooge2"] --> Stooge?.self
        guard parser.succeeded else { return nil }
        self.init(stooge1: stooge1!, stooge2: stooge2)
    }
}


class RawRepresentableTests: XCTestCase {

    func testDecodesRawRepresentables() {
        let json = ["stooge1": "larry", "stooge2": "joe"]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let expected = StoogeStruct(stooge1: .larry, stooge2: .joe)

        let result = DataParser().parse(data: data, to: StoogeStruct.self)

        XCTAssertEqual(result.value, expected)
        XCTAssertEqual(result.errors, [])
    }

    func testErrorsOnUnknownOption() {
        let json = ["stooge1": "larry", "stooge2": "cletus"]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let expected = StoogeStruct(stooge1: .larry, stooge2: nil)

        let result = DataParser().parse(data: data, to: StoogeStruct.self)

        XCTAssertEqual(result.value, expected)
        XCTAssertEqual(result.errors.count, 1)
        XCTAssertEqual(result.errors.first?.type, ParseErrorType.other(message: "Raw value of \"cletus\" for type Stooge not defined"))
    }
}
