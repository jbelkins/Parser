//
//  BoolTests.swift
//  LastMile
//
//  Copyright (c) 2019 Josh Elkins
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
//

import XCTest
import LastMile


fileprivate struct BoolContainer: APIDecodable {
    let bool: Bool

    init?(from decoder: APIDecoder) {
        guard let bool = decoder["bool"] --> Bool.self else { return nil }
        self.bool = bool
    }
}


class BoolTests: XCTestCase {

    func testDecodesTrue() {
        let json = ["bool": true]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: BoolContainer.self)
        if let decoded = result.value?.bool {
            XCTAssertTrue(decoded)
        } else {
            XCTFail("Boolean failed to decode")
        }
        XCTAssertEqual(result.errors, [])
    }

    func testDecodesFalse() {
        let json = ["bool": false]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: BoolContainer.self)
        if let decoded = result.value?.bool {
            XCTAssertFalse(decoded)
        } else {
            XCTFail("Boolean failed to decode")
        }
        XCTAssertEqual(result.errors, [])
    }

    func testErrorsOnMissing() {
        let json = [String: Any]()
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: BoolContainer.self)
        XCTAssertNil(result.value?.bool)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "bool"], actual: .absent)])
    }

    func testErrorsOnNull() {
        let json = ["bool": NSNull()]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: BoolContainer.self)
        XCTAssertNil(result.value?.bool)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "bool"], actual: .null)])
    }
}
