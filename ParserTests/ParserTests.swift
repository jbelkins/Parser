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
    let testStruct1 = ParseableStruct(id: 8675309, name: "test struct 1", optionalDescription: "Cool structure")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeserializes() {
        let data = jsonData(from: testJSON1)
        var parser = try! Parser(data: data)
        let newStruct = parser.parse(rootType: ParseableStruct.self)
        XCTAssertEqual(newStruct, testStruct1)
    }
    
    func jsonData(from object: Any?) -> Data {
        guard let object = object else { return Data() }
        let data = try? JSONSerialization.data(withJSONObject: object, options: [])
        return data ?? Data()
    }
    
}
