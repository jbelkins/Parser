//
//  ParserTests.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import XCTest
@testable import Parser

class ParserTests: XCTestCase {
    let testJSON1: [String: Any] = [
        "id": 8675309,
        "name": "test struct 1",
        "description": "Cool structure"
    ]
    var testStruct1 = ParseableStruct(id: 8675309, name: "test struct 1", optionalDescription: "Cool structure", substruct: nil)
    let testSubStruct1 = ParseableSubStruct(identifier: "Cool sub structure")
    let testSubJSON1: [String: Any] = [
        "identifier": "Cool sub structure"
    ]
    var testJSON2: [String: Any]!
    
    override func setUp() {
        super.setUp()
        testJSON2 = testJSON1
        testJSON2["substruct"] = testSubJSON1
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeserializesAStruct() {
        let data = jsonData(from: testJSON1)
        var parser = try! Parser(data: data)
        let newStruct = parser.parse(rootType: ParseableStruct.self)
        XCTAssertEqual(newStruct, testStruct1)
    }

    func testDeserializesAStructWithSubStruct() {
        let data = jsonData(from: testJSON2)
        var parser = try! Parser(data: data)
        testStruct1.substruct = testSubStruct1
        let newStruct = parser.parse(rootType: ParseableStruct.self)
        XCTAssertEqual(newStruct, testStruct1)
    }

    func testParsesAnError() {
        var badTestJSON1 = testJSON1
        badTestJSON1.removeValue(forKey: "name")
        let data = jsonData(from: badTestJSON1)
        var parser = try! Parser(data: data)
        let newStruct = parser.parse(rootType: ParseableStruct.self)
        XCTAssertNil(newStruct)
        print(parser.errors.first!)
        XCTAssertTrue(parser.errors.count == 1)
        XCTAssertEqual(parser.errors.first!.message, "Missing String")
        XCTAssertEqual(parser.errors.first!.path.map { $0.jsonKey }, ["root", "name"])
        XCTAssertEqual(parser.errors.first!.path.first!.id, "8675309")
    }
    
    func jsonData(from object: Any?) -> Data {
        guard let object = object else { return Data() }
        let data = try? JSONSerialization.data(withJSONObject: object, options: [])
        return data ?? Data()
    }
    
}
