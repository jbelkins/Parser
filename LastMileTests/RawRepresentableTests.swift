//
//  RawRepresentableTests.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/28/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import XCTest
import LastMile


enum Stooge: String, APIDecodable {
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


extension StoogeStruct: APIDecodable {

    init?(from decoder: APIDecoder) {
        let stooge1 = decoder["stooge1"] --> Stooge.self
        let stooge2 = decoder["stooge2"] --> Stooge?.self
        guard decoder.succeeded else { return nil }
        self.init(stooge1: stooge1!, stooge2: stooge2)
    }
}


class RawRepresentableTests: XCTestCase {

    func testDecodesRawRepresentables() {
        let json = ["stooge1": "larry", "stooge2": "joe"]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let expected = StoogeStruct(stooge1: .larry, stooge2: .joe)

        let result = APIDataDecoder().decode(data: data, to: StoogeStruct.self)

        XCTAssertEqual(result.value, expected)
        XCTAssertEqual(result.errors, [])
    }

    func testErrorsOnUnknownOption() {
        let json = ["stooge1": "larry", "stooge2": "cletus"]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let expected = StoogeStruct(stooge1: .larry, stooge2: nil)

        let result = APIDataDecoder().decode(data: data, to: StoogeStruct.self)

        XCTAssertEqual(result.value, expected)
        let path: [APICodingKey] = ["root", "stooge2"]
        let reason = APIDecodeErrorReason.unexpectedRawValue(value: "cletus", type: "Stooge")
        let error = APIDecodeError(path: path, reason: reason)
        XCTAssertEqual(result.errors, [error])
    }
}
