//
//  RawRepresentableTests.swift
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


enum Stooge: String, APIDecodable {
    case larry
    case curly
    case moe
    case shep
    case joe
}


struct StoogeStruct: Equatable {
    let stooge1: Stooge
    let stooge2: Stooge?
}


extension StoogeStruct: APIDecodable {

    init?(from decoder: APIDecoder) {
        let stooge1 = decoder["stooge1"] --> Stooge.self
        let stooge2 = decoder["stooge2"] --> Stooge?.self
        guard decoder.succeeded else { return nil }
        self.init(stooge1: stooge1!, stooge2: stooge2)
    }
}


class RawRepresentableTests: XCTestCase {

    func testDecodesRawRepresentables() {
        let json = ["stooge1": "larry", "stooge2": "joe"]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let expected = StoogeStruct(stooge1: .larry, stooge2: .joe)

        let result = APIDataDecoder().decode(data: data, to: StoogeStruct.self)

        XCTAssertEqual(result.value, expected)
        XCTAssertEqual(result.errors, [])
    }

    func testErrorsOnUnknownOption() {
        let json = ["stooge1": "larry", "stooge2": "cletus"]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let expected = StoogeStruct(stooge1: .larry, stooge2: nil)

        let result = APIDataDecoder().decode(data: data, to: StoogeStruct.self)

        XCTAssertEqual(result.value, expected)
        let path: [APICodingKey] = ["root", "stooge2"]
        let reason = APIDecodeErrorReason.unexpectedRawValue(value: "cletus", type: "Stooge")
        let error = APIDecodeError(path: path, reason: reason)
        XCTAssertEqual(result.errors, [error])
    }
}
