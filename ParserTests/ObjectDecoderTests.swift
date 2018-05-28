//
//  ObjectDecoderTests.swift
//  ParserTests
//
//  Created by Josh Elkins on 5/28/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation
import XCTest
import Parser


struct SampleCodableData: Codable, Equatable {
    let id: Int
    let name: String
    let address: String
    let intOrNot: Int?
    let stringOrNot: String?
    let numbahs: [Double]
    let valyews: [String: UInt8]
}


class ObjectDecoderTests: XCTestCase {

    func testDecodesANewInstance() {
        let jsonObject: [String : Any] = ["id": 123, "name": "xyz", "address": "abc", "intOrNot": NSNull(), "numbahs": [8, 6, 7, 5, 3, 0, 9], "valyews": ["wun": 1, "tyew": 2, "big": 255]]
        let expected = SampleCodableData(id: 123, name: "xyz", address: "abc", intOrNot: nil, stringOrNot: nil, numbahs: [8, 6, 7, 5, 3, 0, 9], valyews: ["wun": 1, "tyew": 2, "big": 255])
        let decoder = ObjectDecoder(jsonObject: jsonObject)
        var actual: SampleCodableData?
        XCTAssertNoThrow(actual = try SampleCodableData(from: decoder))
        XCTAssertEqual(actual, expected)
    }
}
