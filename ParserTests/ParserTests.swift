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
    let testJSON1: [String: Any] = [
        "id": 8675309,
        "name": "test struct 1",
        "description": "Cool structure",
        "substruct": [
            "identifier": "Cool sub structure"
        ],
        "substructs": [
            ["identifier": "Cool array element 0"],
            ["identifier": "Cool array element 1"]
        ]
    ]
    var testStruct1 = ParseableStruct(id: 8675309, name: "test struct 1", first: ParseableSubStruct(identifier: "Cool array element 0"), optionalDescription: "Cool structure", substruct: ParseableSubStruct(identifier: "Cool sub structure"))

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeserializesAStruct() {
        let data = jsonData(from: testJSON1)
        let parser = try! DataParser(data: data)
        let newStruct = parser.parse(ParseableStruct.self)
        XCTAssertEqual(newStruct, testStruct1)
    }

    func testDeserializesAStructWithSubStruct() {
        let data = jsonData(from: testJSON1)
        let parser = try! DataParser(data: data)
        let newStruct = parser.parse(ParseableStruct.self)
        XCTAssertEqual(newStruct, testStruct1)
    }

    func testParsesAnError() {
        var badTestJSON1 = testJSON1
        badTestJSON1.removeValue(forKey: "name")
        let data = jsonData(from: badTestJSON1)
        let parser = try! DataParser(data: data)
        let newStruct = parser.parse(ParseableStruct.self)
        XCTAssertNil(newStruct)
        XCTAssertTrue(parser.errors.count == 1)
        XCTAssertEqual(parser.errors.first!.message, "Missing String")
        XCTAssertEqual(parser.errors.first!.path.map { $0.hashKey! }, ["root", "name"])
    }

    func testParsesAnErrorInAnOptional() {
        let badTestJSON1: [String: Any] = [
            "id": 8675309,
            "name": "test struct 1",
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
        let parser = try! DataParser(data: data)
        let newStruct = parser.parse(ParseableStruct.self)
        XCTAssertNotNil(newStruct)
        XCTAssertTrue(parser.errors.count == 1)
        XCTAssertTrue(parser.errors.first!.message.hasPrefix("Not a String"))
        XCTAssertEqual(parser.errors.first!.path.map { $0.hashKey! }, ["root", "substruct", "identifier"])
    }
    
    func jsonData(from object: Any?) -> Data {
        guard let object = object else { return Data() }
        let data = try? JSONSerialization.data(withJSONObject: object, options: [])
        return data ?? Data()
    }
    
}
