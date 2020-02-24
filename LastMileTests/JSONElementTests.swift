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
        let node = JSONNode(contents: .object([String: JSONNode]()))
        XCTAssertEqual(node.type, .object)
    }

    func testArrayIsArray() {
        let node = JSONNode(contents: .array([JSONNode]()))
        XCTAssertEqual(node.type, .array)
    }

    func testIntegerNSNumberIsInteger() {
        let node = JSONNode(contents: .number(NSNumber(value: 12)))
        XCTAssertEqual(node.type, .integer)
    }

    func testDecimalNSNumberIsDecimal() {
        let node = JSONNode(contents: .number(NSNumber(value: 12.5)))
        XCTAssertEqual(node.type, .decimal)
    }

    func testBooleanNSNumberIsBool() {
        let node = JSONNode(contents: .bool(true))
        XCTAssertEqual(node.type, .boolean)
    }

    func testStringIsAString() {
        let node = JSONNode(contents: .string("name"))
        XCTAssertEqual(node.type, .string)
    }

    func testNSNullIsNull() {
        let node = JSONNode(contents: .null)
        XCTAssertEqual(node.type, .null)
    }
}
