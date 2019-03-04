//
//  ParserTests.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import XCTest
import LastMile


class ParserTests: XCTestCase {
    var testJSON1: [String: Any]!
    var testStruct1: MainDecodableStruct!
    var subStruct1: DecodableSubStruct!
    var subStruct2: DecodableSubStruct!
    var decodableStruct: SwiftDecodableStruct!

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
            ],
            "indexed": [
                "onesy": ["identifier": "Cool array element 0"],
                "twosy": ["identifier": "Cool array element 1"]
            ],
            "truthy": false,
            "falsey": true,
            "decodable": [
                "id": 123,
                "name": "Decodable",
                "notes": "Pretty cool"
            ]
        ]
        subStruct1 = DecodableSubStruct(identifier: "Cool array element 0")
        subStruct2 = DecodableSubStruct(identifier: "Cool array element 1")
        decodableStruct = SwiftDecodableStruct(id: 123, name: "Decodable", notes: "Pretty cool")
        let subArray = [subStruct1!, subStruct2!]
        let subDict = ["onesy": subStruct1!, "twosy": subStruct2!]
        testStruct1 = MainDecodableStruct(id: 8675309, name: "test struct 1", subArray: subArray, null: NSNull(), indexed: subDict, truthy: false, decodable: decodableStruct, falsey: true, decimal: 3.776, description: "Cool structure", substruct: DecodableSubStruct(identifier: "Cool sub structure"))
    }

    func testDeserializesAStruct() {
        let data = jsonData(from: testJSON1)
        let result = APIDataDecoder().decode(data: data, to: MainDecodableStruct.self)
        XCTAssertEqual(result.value, testStruct1)
    }

    func testDeserializesAStructWithSubStruct() {
        let data = jsonData(from: testJSON1)
        let result = APIDataDecoder().decode(data: data, to: MainDecodableStruct.self)
        XCTAssertEqual(result.value, testStruct1)
    }

    func testDeserializesAnArray() {
        let data = jsonData(from: testJSON1)
        let result = APIDataDecoder().decode(data: data, to: MainDecodableStruct.self)
        XCTAssertEqual(result.value?.subArray.count, 2)
        XCTAssertEqual(result.value?.subArray ?? [], [subStruct1, subStruct2])
    }

    func testParsesAnError() {
        var badTestJSON1 = testJSON1!
        badTestJSON1.removeValue(forKey: "name")
        let data = jsonData(from: badTestJSON1)
        let result = APIDataDecoder().decode(data: data, to: MainDecodableStruct.self)
        XCTAssertNil(result.value)
        XCTAssertEqual(result.errors.count, 1)
        XCTAssertEqual(result.errors.first?.reason, .unexpectedJSONType(actual: .absent))
        XCTAssertEqual(result.errors.map { $0.path.jsonPath }, ["root[\"name\"]"])
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
            ],
            "indexed": [
                "onesy": ["identifier": "Cool array element 0"],
                "twosy": ["identifier": "Cool array element 1"]
            ],
            "truthy": false,
            "falsey": true,
            "decodable": [
                "id": 123,
                "name": "Decodable",
                "notes": "Pretty cool"
            ]
        ]
        let data = jsonData(from: badTestJSON1)
        let result = APIDataDecoder().decode(data: data, to: MainDecodableStruct.self)
        XCTAssertNotNil(result.value)
        XCTAssertEqual(result.errors.count, 1)
        XCTAssertEqual(result.errors.first?.reason, .unexpectedJSONType(actual: .integer))
        XCTAssertEqual(result.errors.map { $0.path.jsonPath }, ["root[\"substruct\"][\"identifier\"]"])
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
            ],
            "indexed": [
                "onesy": ["identifier": "Cool array element 0"],
                "twosy": ["identifier": "Cool array element 1"]
            ],
            "truthy": false,
            "falsey": true,
            "decodable": [
                "id": 123,
                "name": "Decodable",
                "notes": "Pretty cool"
            ]
        ]
        let data = jsonData(from: badTestJSON1)
        let result = APIDataDecoder().decode(data: data, to: MainDecodableStruct.self)
        XCTAssertNil(result.value)
        XCTAssertEqual(result.errors.count, 2)
        XCTAssertEqual(result.errors.first?.reason, .unexpectedJSONType(actual: .decimal))
        XCTAssertEqual(result.errors.last?.reason, .unexpectedJSONType(actual: .integer))
        XCTAssertEqual(result.errors.map { $0.path.jsonPath }, ["root[\"name\"]", "root[\"substruct\"][\"identifier\"]"])
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
            ],
            "indexed": [
                "onesy": ["identifier": "Cool array element 0"],
                "twosy": ["identifier": "Cool array element 1"]
            ],
            "truthy": false,
            "falsey": true,
            "decodable": [
                "id": 123,
                "name": "Decodable",
                "notes": "Pretty cool"
            ]
        ]
        let data = jsonData(from: badTestJSON1)
        let result = APIDataDecoder().decode(data: data, to: MainDecodableStruct.self)
        XCTAssertEqual(result.errors.count, 1)
        XCTAssertEqual(result.errors.first?.reason, .unexpectedJSONType(actual: .absent))
        XCTAssertEqual(result.errors.first?.path.jsonPath, "root[\"substructs\"][2][\"identifier\"]")
        XCTAssertEqual(result.value?.subArray.count, 2)
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
            ],
            "indexed": [
                "onesy": ["identifier": "Cool array element 0"],
                "twosy": ["identifier": "Cool array element 1"]
            ],
            "truthy": false,
            "falsey": true,
            "decodable": [
                "id": 123,
                "name": "Decodable",
                "notes": "Pretty cool"
            ]
        ]
        let data = jsonData(from: badTestJSON1)
        let result = APIDataDecoder().decode(data: data, to: MainDecodableStruct.self)
        XCTAssertNotNil(result.value)
        XCTAssertEqual(result.value?.decimal, 4)
    }

    func jsonData(from object: Any?) -> Data {
        guard let object = object else { return Data() }
        let data = try? JSONSerialization.data(withJSONObject: object, options: [])
        return data ?? Data()
    }
}
