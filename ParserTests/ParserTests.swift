//
//  ParserTests.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import XCTest
import Parser


class ParserTests: XCTestCase {
    var testJSON1: [String: Any]!
    var testStruct1: ParseableStruct!
    var subStruct1: ParseableSubStruct!
    var subStruct2: ParseableSubStruct!

    override func setUp() {
        super.setUp()
        testJSON1 = [
            "id": 8675309,
            "name": "test struct 1",
            "substruct": [
                "identifier": "Cool sub structure"
            ],
            "null": NSNull(),
            "decimal": 3.776,
            "description": "Cool structure",
            "substructs": [
                ["identifier": "Cool array element 0"],
                ["identifier": "Cool array element 1"]
            ]
        ]
        subStruct1 = ParseableSubStruct(identifier: "Cool array element 0")
        subStruct2 = ParseableSubStruct(identifier: "Cool array element 1")
        testStruct1 = ParseableStruct(id: 8675309, name: "test struct 1", subArray: [subStruct1, subStruct2], null: NSNull(), decimal: 3.776, description: "Cool structure", substruct: ParseableSubStruct(identifier: "Cool sub structure"))
    }

    func testDeserializesAStruct() {
        let data = jsonData(from: testJSON1)
        let (newStruct, _) = try! DataParser.parse(data: data, to: ParseableStruct.self)
        XCTAssertEqual(newStruct, testStruct1)
    }

    func testDeserializesAStructWithSubStruct() {
        let data = jsonData(from: testJSON1)
        let (newStruct, _) = try! DataParser.parse(data: data, to: ParseableStruct.self)
        XCTAssertEqual(newStruct, testStruct1)
    }

    func testDeserializesAnArray() {
        let data = jsonData(from: testJSON1)
        let (newStruct, _) = try! DataParser.parse(data: data, to: ParseableStruct.self)
        XCTAssertEqual(newStruct?.subArray.count, 2)
        XCTAssertEqual(newStruct?.subArray ?? [], [subStruct1, subStruct2])
    }

    func testParsesAnError() {
        var badTestJSON1 = testJSON1!
        badTestJSON1.removeValue(forKey: "name")
        let data = jsonData(from: badTestJSON1)
        let (newStruct, errors) = try! DataParser.parse(data: data, to: ParseableStruct.self)
        XCTAssertNil(newStruct)
        XCTAssertEqual(errors.count, 1)
        XCTAssertEqual(errors.first?.message, "Expected String, got absent")
        XCTAssertEqual(errors.map { $0.path.jsonPath }, ["root[\"name\"]"])
    }

    func testParsesAnErrorInAnOptional() {
        let badTestJSON1: [String: Any] = [
            "id": 8675309,
            "name": "test struct 1",
            "null": NSNull(),
            "decimal": 3.776,
            "description": "Cool structure",
            "substruct": [
                "identifier": 123321
            ],
            "substructs": [
                ["identifier": "Cool array element 0"],
                ["identifier": "Cool array element 1"]
            ]
        ]
        let data = jsonData(from: badTestJSON1)
        let (newStruct, errors) = try! DataParser.parse(data: data, to: ParseableStruct.self)
        XCTAssertNotNil(newStruct)
        XCTAssertEqual(errors.count, 1)
        XCTAssertEqual(errors.first?.message, "Expected String, got Int")
        XCTAssertEqual(errors.map { $0.path.jsonPath }, ["root[\"substruct\"][\"identifier\"]"])
    }

    func testParsesAWrongTypeError() {
        let badTestJSON1: [String: Any] = [
            "id": 8675309,
            "name": 17.25,
            "null": NSNull(),
            "decimal": 3.776,
            "description": "Cool structure",
            "substruct": [
                "identifier": 123321
            ],
            "substructs": [
                ["identifier": "Cool array element 0"],
                ["identifier": "Cool array element 1"]
            ]
        ]
        let data = jsonData(from: badTestJSON1)
        let (newStruct, errors) = try! DataParser.parse(data: data, to: ParseableStruct.self)
        XCTAssertNil(newStruct)
        XCTAssertEqual(errors.count, 2)
        XCTAssertEqual(errors.map { $0.message }, ["Expected String, got Double", "Expected String, got Int"])
        XCTAssertEqual(errors.map { $0.path.jsonPath }, ["root[\"name\"]", "root[\"substruct\"][\"identifier\"]"])
    }

    func testParsesAWrongTypeErrorInAnArray() {
        let badTestJSON1: [String: Any] = [
            "id": 8675309,
            "name": "test struct 1",
            "null": NSNull(),
            "decimal": 3.776,
            "description": "Cool structure",
            "substruct": [
                "identifier": "Cool sub structure"
            ],
            "substructs": [
                ["identifier": "Cool array element 0"],
                ["identifier": "Cool array element 1"],
                true
            ]
        ]
        let data = jsonData(from: badTestJSON1)
        let (newStruct, errors) = try! DataParser.parse(data: data, to: ParseableStruct.self)
        XCTAssertEqual(errors.count, 1)
        XCTAssertEqual(errors.first?.message, "Expected [String: Any], got Bool")
        XCTAssertEqual(errors.first?.path.jsonPath, "root[\"substructs\"][2]")
        XCTAssertEqual(newStruct?.subArray.count, 2)
    }

    func testParsesAnIntToADouble() {
        let badTestJSON1: [String: Any] = [
            "id": 8675309,
            "name": "test struct 1",
            "null": NSNull(),
            "decimal": 4,
            "description": "Cool structure",
            "substruct": [
                "identifier": "Cool sub structure"
            ],
            "substructs": [
                ["identifier": "Cool array element 0"],
                ["identifier": "Cool array element 1"]
            ]
        ]
        let data = jsonData(from: badTestJSON1)
        let (newStruct, _) = try! DataParser.parse(data: data, to: ParseableStruct.self)
        XCTAssertNotNil(newStruct)
        XCTAssertEqual(newStruct?.decimal, 4)
    }

    func jsonData(from object: Any?) -> Data {
        guard let object = object else { return Data() }
        let data = try? JSONSerialization.data(withJSONObject: object, options: [])
        return data ?? Data()
    }
    
}
