//
//  IntegerTests.swift
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


fileprivate struct TestContainer<T: APIDecodable & Equatable>: Equatable {
    let value: T
}


extension TestContainer: APIDecodable {

    init?(from decoder: APIDecoder) {
        guard let v = decoder["value"] --> T.self else { return nil }
        self.init(value: v)
    }
}


class IntegerTests: XCTestCase {

    //  MARK: - Overflow errors

    func testErrorsOnAnInt8Overflow() {
        performOverflowTest(on: Int8.self)
    }

    func testErrorsOnAnInt16Overflow() {
        performOverflowTest(on: Int16.self)
    }

    func testErrorsOnAnInt32Overflow() {
        performOverflowTest(on: Int32.self)
    }

    //  Note that Int and Int64 are not tested for overflow because
    //  NSJSONSerialization will not return an integral value greater than 64 bits.

    // MARK: - Loss of precision errors

    func testErrorsOnInt8LossOfPrecision() {
        performPrecisionTest(on: Int8.self)
    }

    func testErrorsOnInt16LossOfPrecision() {
        performPrecisionTest(on: Int16.self)
    }

    func testErrorsOnInt32LossOfPrecision() {
        performPrecisionTest(on: Int32.self)
    }

    func testErrorsOnInt64LossOfPrecision() {
        performPrecisionTest(on: Int64.self)
    }

    func testErrorsOnIntLossOfPrecision() {
        performPrecisionTest(on: Int.self)
    }

    // MARK: - Private methods

    private func performOverflowTest<T: APIDecodable & FixedWidthInteger & Equatable>(on type: T.Type) {
        let tooBig = Int(T.max) + 1
        let json = ["value": tooBig]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: TestContainer<T>.self)

        XCTAssertNil(result.value)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "value"], reason: .numericOverflow(value: Decimal(tooBig), type: "\(T.self)"))])
    }

    private func performPrecisionTest<T: APIDecodable & FixedWidthInteger & Equatable>(on type: T.Type) {
        let notWhole = 12.5
        let json = ["value": notWhole]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: TestContainer<T>.self)

        XCTAssertNil(result.value)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "value"], reason: .lossOfPrecision(value: Decimal(notWhole), type: "\(T.self)"))])
    }
}
