//
//  JSONElementTests.swift
//  ParserTests
//
//  Created by Josh Elkins on 3/1/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import XCTest
@testable import LastMile


class JSONElementTests: XCTestCase {

    func testDictIsAnObject() {
        let type = JSONElement.type(for: [AnyHashable: Any]())
        XCTAssertEqual(type, .object)
    }

    func testArrayIsArray() {
        let type = JSONElement.type(for: [Any]())
        XCTAssertEqual(type, .array)
    }

    func testIntegerNSNumberIsInteger() {
        let type = JSONElement.type(for: NSNumber(value: 12))
        XCTAssertEqual(type, .integer)
    }

    func testDecimalNSNumberIsDecimal() {
        let type = JSONElement.type(for: NSNumber(value: 12.5))
        XCTAssertEqual(type, .decimal)
    }

    func testBooleanNSNumberIsBool() {
        let type = JSONElement.type(for: NSNumber(value: true))
        XCTAssertEqual(type, .boolean)
    }

    func testStringIsAString() {
        let type = JSONElement.type(for: "name")
        XCTAssertEqual(type, .string)
    }

    func testNSNullIsNull() {
        let type = JSONElement.type(for: NSNull())
        XCTAssertEqual(type, .null)
    }

    func testNilJSONIsAbsent() {
        let type = JSONElement.type(for: nil)
        XCTAssertEqual(type, .absent)
    }
}
