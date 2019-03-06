//
//  ResponseDataTests.swift
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
import LastMile


class ResponseDataTests: XCTestCase {

    func testSucceedsWithRequestData() {
        let data = "thisissomebinarydata.".data(using: .utf8)
        let result = APIDataDecoder().decode(data: data, to: ResponseData.self)
        XCTAssertNotNil(result.value)
        XCTAssertEqual(result.value?.data, data)
        XCTAssertEqual(result.errors, [])
    }

    func testSucceedsWithoutRequestData() {
        let result = APIJSONObjectDecoder().decode(json: nil, to: ResponseData.self)
        XCTAssertNotNil(result.value)
        XCTAssertEqual(result.value?.data, nil)
        XCTAssertEqual(result.errors, [])
    }
}
