//
//  JSONElementTests.swift
//  ParserTests
//
//  Created by Josh Elkins on 3/1/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import XCTest
@testable import Parser


class JSONElementTests: XCTestCase {

    func testDictIsAnObject() {
        let types = JSONElement.types(for: [AnyHashable: Any]())
        XCTAssertEqual(types, [.object])
    }

    func testArrayIsArray() {
        let types = JSONElement.types(for: [Any]())
        XCTAssertEqual(types, [.array])
    }

    func testIntegerNSNumberIsIntOrDouble() {
        let types = JSONElement.types(for: NSNumber(value: 12))
        XCTAssertEqual(types, [.int, .double])
    }

    func testDecimalNSNumberIsDouble() {
        let types = JSONElement.types(for: NSNumber(value: 12.5))
        XCTAssertEqual(types, [.double])
    }

    func testBooleanNSNumberIsBool() {
        let types = JSONElement.types(for: NSNumber(value: true))
        XCTAssertEqual(types, [.bool])
    }

    func testStringIsAString() {
        let types = JSONElement.types(for: "name")
        XCTAssertEqual(types, [.string])
    }

    func testNSNullIsNull() {
        let types = JSONElement.types(for: NSNull())
        XCTAssertEqual(types, [.null])
    }

    func testNilJSONIsAbsent() {
        let types = JSONElement.types(for: nil)
        XCTAssertEqual(types, [.absent])
    }
}
