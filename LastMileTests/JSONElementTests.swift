//
//  JSONElementTests.swift
//  LastMile
//
//  Copyright (c) 2018 Josh Elkins
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
