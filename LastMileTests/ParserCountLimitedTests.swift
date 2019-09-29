//
//  ParserCountLimitedTests.swift
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


struct TestArrays: Equatable {
    let arrayWithMin: [Int]
    let arrayWithMax: [Int]
    let arrayWithExact: [Int]
    let nonMandatoryArray: [Int]
}


extension TestArrays: APIDecodable {
    static let idKey: String? = nil

    init?(from decoder: APIDecoder) {
        let arrayWithMin = decoder["arrayWithMin"] --> CountLimited<[Int]>(min: 2, isMandatory: false)
        let arrayWithMax = decoder["arrayWithMax"] --> CountLimited<[Int]>(max: 2, isMandatory: true)
        let arrayWithExact = decoder["arrayWithExact"] --> CountLimited<[Int]>(exactly: 2, isMandatory: true)
        let nonMandatoryArray = decoder["nonmandatory"] --> CountLimited<[Int]>(exactly: 2, isMandatory: false)
        guard decoder.succeeded else { return nil }
        self.init(arrayWithMin: arrayWithMin!, arrayWithMax: arrayWithMax!, arrayWithExact: arrayWithExact!, nonMandatoryArray: nonMandatoryArray!)
    }
}


struct TestDicts: Equatable {
    let dictWithMin: [String: Int]
    let dictWithMax: [String: Int]
    let dictWithExact: [String: Int]
    let nonMandatoryDict: [String: Int]
}


extension TestDicts: APIDecodable {
    static var idKey: String? = nil

    init?(from decoder: APIDecoder) {
        let dictWithMin = decoder["dictWithMin"] --> CountLimited<[String: Int]>(min: 2, isMandatory: true)
        let dictWithMax = decoder["dictWithMax"] --> CountLimited<[String: Int]>(max: 2, isMandatory: true)
        let dictWithExact = decoder["dictWithExact"] --> CountLimited<[String: Int]>(exactly: 2, isMandatory: true)
        let nonMandatoryDict = decoder["nonmandatory"] --> CountLimited<[String: Int]>(exactly: 2, isMandatory: false)
        guard decoder.succeeded else { return nil }
        self.init(dictWithMin: dictWithMin!, dictWithMax: dictWithMax!, dictWithExact: dictWithExact!, nonMandatoryDict: nonMandatoryDict!)
    }
}


class ParserCountLimitedTests: XCTestCase {

    // MARK: - Array tests

    func testArraySucceedsWhenCountsAreSatisfied() {
        let jsonObject = ["arrayWithMin": [1, 2], "arrayWithMax": [3, 4], "arrayWithExact": [5, 6], "nonmandatory": [7, 8]]
        let result = APIJSONObjectDecoder().decode(jsonObject: jsonObject, to: TestArrays.self)
        XCTAssertEqual(result.value, TestArrays(arrayWithMin: [1, 2], arrayWithMax: [3, 4], arrayWithExact: [5, 6], nonMandatoryArray: [7, 8]))
        XCTAssertEqual(result.errors, [])
    }

    func testArrayFailsWhenAMandatoryMinIsExceeded() {
        let jsonObject = ["arrayWithMin": [1], "arrayWithMax": [3, 4], "arrayWithExact": [5, 6], "nonmandatory": [7, 8]]
        let result = APIJSONObjectDecoder().decode(jsonObject: jsonObject, to: TestArrays.self)
        XCTAssertEqual(result.value, TestArrays(arrayWithMin: [1], arrayWithMax: [3, 4], arrayWithExact: [5, 6], nonMandatoryArray: [7, 8]))
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "arrayWithMin"], minimum: 2, actual: 1)])
    }

    func testArrayFailsWhenBelowExactCount() {
        let jsonObject = ["arrayWithMin": [1, 2], "arrayWithMax": [3, 4], "arrayWithExact": [5], "nonmandatory": [7, 8]]
        let result = APIJSONObjectDecoder().decode(jsonObject: jsonObject, to: TestArrays.self)
        XCTAssertNil(result.value)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "arrayWithExact"], expected: 2, actual: 1)])
    }

    func testArrayFailsWhenAboveExactCount() {
        let jsonObject = ["arrayWithMin": [1, 2], "arrayWithMax": [3, 4], "arrayWithExact": [5, 6, 7], "nonmandatory": [7, 8]]
        let result = APIJSONObjectDecoder().decode(jsonObject: jsonObject, to: TestArrays.self)
        XCTAssertNil(result.value)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "arrayWithExact"], expected: 2, actual: 3)])
    }

    func testArraySucceedsWithErrorOnNonMandatoryFail() {
        let jsonObject = ["arrayWithMin": [1, 2], "arrayWithMax": [3, 4], "arrayWithExact": [5, 6], "nonmandatory": [7, 8, 9]]
        let result = APIJSONObjectDecoder().decode(jsonObject: jsonObject, to: TestArrays.self)
        XCTAssertEqual(result.value, TestArrays(arrayWithMin: [1, 2], arrayWithMax: [3, 4], arrayWithExact: [5, 6], nonMandatoryArray: [7, 8, 9]))
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "nonmandatory"], expected: 2, actual: 3)])
    }

    // MARK: - Array tests

    func testDictSucceedsWhenCountsAreSatisfied() {
        let jsonObject = ["dictWithMin": ["a": 1, "b": 2], "dictWithMax": ["c": 3, "d": 4], "dictWithExact": ["e": 5, "f": 6], "nonmandatory": ["g": 7, "h": 8]]
        let result = APIJSONObjectDecoder().decode(jsonObject: jsonObject, to: TestDicts.self)
        XCTAssertEqual(result.value, TestDicts(dictWithMin: ["a": 1, "b": 2], dictWithMax: ["c": 3, "d": 4], dictWithExact: ["e": 5, "f": 6], nonMandatoryDict: ["g": 7, "h": 8]))
        XCTAssertEqual(result.errors, [])
    }

    func testDictFailsWhenAMandatoryMinIsExceeded() {
        let jsonObject = ["dictWithMin": ["a": 1], "dictWithMax": ["c": 3, "d": 4], "dictWithExact": ["e": 5, "f": 6], "nonmandatory": ["g": 7, "h": 8]]
        let result = APIJSONObjectDecoder().decode(jsonObject: jsonObject, to: TestDicts.self)
        XCTAssertNil(result.value)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "dictWithMin"], minimum: 2, actual: 1)])
    }

    func testDictFailsWhenBelowExactCount() {
        let jsonObject = ["dictWithMin": ["a": 1, "b": 2], "dictWithMax": ["c": 3, "d": 4], "dictWithExact": ["e": 5], "nonmandatory": ["g": 7, "h": 8]]
        let result = APIJSONObjectDecoder().decode(jsonObject: jsonObject, to: TestDicts.self)
        XCTAssertNil(result.value)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "dictWithExact"], expected: 2, actual: 1)])
    }

    func testDictFailsWhenAboveExactCount() {
        let jsonObject = ["dictWithMin": ["a": 1, "b": 2], "dictWithMax": ["c": 3, "d": 4], "dictWithExact": ["e": 5, "f": 6, "g": 7], "nonmandatory": ["g": 7, "h": 8]]
        let result = APIJSONObjectDecoder().decode(jsonObject: jsonObject, to: TestDicts.self)
        XCTAssertNil(result.value)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "dictWithExact"], expected: 2, actual: 3)])
    }

    func testDictSucceedsWithErrorOnNonMandatoryFail() {
        let jsonObject = ["dictWithMin": ["a": 1, "b": 2], "dictWithMax": ["c": 3, "d": 4], "dictWithExact": ["e": 5, "f": 6], "nonmandatory": ["g": 7, "h": 8, "i": 9]]
        let result = APIJSONObjectDecoder().decode(jsonObject: jsonObject, to: TestDicts.self)
        XCTAssertEqual(result.value, TestDicts(dictWithMin: ["a": 1, "b": 2], dictWithMax: ["c": 3, "d": 4], dictWithExact: ["e": 5, "f": 6], nonMandatoryDict: ["g": 7, "h": 8, "i": 9]))
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "nonmandatory"], expected: 2, actual: 3)])
    }
}
