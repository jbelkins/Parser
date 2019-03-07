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


fileprivate struct IntegerContainer<T: APIDecodable & Equatable>: APIDecodable {
    let integer: T

    init?(from decoder: APIDecoder) {
        guard let integer = decoder["integer"] --> T.self else { return nil }
        self.integer = integer
    }
}


class IntegerTests: XCTestCase {

    //  MARK: - Parsing from an in-range integer

    func testDecodesInRangeInt8() {
        performInRangeTest(on: Int8.self)
    }

    func testDecodesInRangeInt16() {
        performInRangeTest(on: Int16.self)
    }

    func testDecodesInRangeInt32() {
        performInRangeTest(on: Int32.self)
    }

    func testDecodesInRangeInt64() {
        performInRangeTest(on: Int64.self)
    }

    func testDecodesInRangeInt() {
        performInRangeTest(on: Int.self)
    }

    func testDecodesInRangeUInt8() {
        performInRangeTest(on: UInt8.self)
    }

    func testDecodesInRangeUInt16() {
        performInRangeTest(on: UInt16.self)
    }

    func testDecodesInRangeUInt32() {
        performInRangeTest(on: UInt32.self)
    }

    func testDecodesInRangeUInt64() {
        performInRangeTest(on: UInt64.self)
    }

    func testDecodesInRangeUInt() {
        performInRangeTest(on: UInt.self)
    }

    //  MARK: - Positive overflow errors

    func testErrorsOnAnInt8Overflow() {
        performOverflowTest(on: Int8.self)
    }

    func testErrorsOnAnInt16Overflow() {
        performOverflowTest(on: Int16.self)
    }

    func testErrorsOnAnInt32Overflow() {
        performOverflowTest(on: Int32.self)
    }

    func testErrorsOnAnInt64Overflow() {
        performOverflowTest(on: Int64.self)
    }

    func testErrorsOnAnIntOverflow() {
        performOverflowTest(on: Int.self)
    }

    func testErrorsOnAUInt8Overflow() {
        performOverflowTest(on: UInt8.self)
    }

    func testErrorsOnAUInt16Overflow() {
        performOverflowTest(on: UInt16.self)
    }

    func testErrorsOnAUInt32Overflow() {
        performOverflowTest(on: UInt32.self)
    }

    func testErrorsOnAUInt64Overflow() {
        performOverflowTest(on: UInt64.self)
    }

    func testErrorsOnAUIntOverflow() {
        performOverflowTest(on: UInt.self)
    }

    // MARK: - Negative overflow errors

    func testErrorsOnAnInt8NegativeOverflow() {
        performNegativeOverflowTest(on: Int8.self)
    }

    func testErrorsOnAnInt16NegativeOverflow() {
        performNegativeOverflowTest(on: Int16.self)
    }

    func testErrorsOnAnInt32NegativeOverflow() {
        performNegativeOverflowTest(on: Int32.self)
    }

    func testErrorsOnAnInt64NegativeOverflow() {
        performNegativeOverflowTest(on: Int64.self)
    }

    func testErrorsOnAnIntNegativeOverflow() {
        performNegativeOverflowTest(on: Int.self)
    }

    func testErrorsOnAUInt8NegativeOverflow() {
        performNegativeOverflowTest(on: UInt8.self)
    }

    func testErrorsOnAUInt16NegativeOverflow() {
        performNegativeOverflowTest(on: UInt16.self)
    }

    func testErrorsOnAUInt32NegativeOverflow() {
        performNegativeOverflowTest(on: UInt32.self)
    }

    func testErrorsOnAUInt64NegativeOverflow() {
        performNegativeOverflowTest(on: UInt64.self)
    }

    func testErrorsOnAUIntNegativeOverflow() {
        performNegativeOverflowTest(on: UInt.self)
    }

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

    func testErrorsOnUInt8LossOfPrecision() {
        performPrecisionTest(on: UInt8.self)
    }

    func testErrorsOnUInt16LossOfPrecision() {
        performPrecisionTest(on: UInt16.self)
    }

    func testErrorsOnUInt32LossOfPrecision() {
        performPrecisionTest(on: UInt32.self)
    }

    func testErrorsOnUInt64LossOfPrecision() {
        performPrecisionTest(on: UInt64.self)
    }

    func testErrorsOnUIntLossOfPrecision() {
        performPrecisionTest(on: UInt.self)
    }

    // MARK: - Private methods

    private func performInRangeTest<T: APIDecodable & FixedWidthInteger & Equatable>(on type: T.Type) {
        let value = NSDecimalNumber(string: "\(T.max)").subtracting(.one)
        let json = ["integer": value]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: IntegerContainer<T>.self)
        guard let decoded = result.value?.integer else {
            XCTFail("\(T.self) failed to decode"); return
        }
        XCTAssertEqual(decoded, T.init("\(value)"))
        XCTAssertEqual(result.errors, [])
    }

    private func performOverflowTest<T: APIDecodable & FixedWidthInteger & Equatable>(on type: T.Type) {
        let tooBig = NSDecimalNumber(string: "\(T.max)").adding(.one)
        let json = ["integer": tooBig]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: IntegerContainer<T>.self)

        XCTAssertNil(result.value)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "integer"], reason: .numericOverflow(value: tooBig.decimalValue, type: "\(T.self)"))])
    }

    private func performNegativeOverflowTest<T: APIDecodable & FixedWidthInteger & Equatable>(on type: T.Type) {
        let tooLow = NSDecimalNumber(string: "\(T.min)").subtracting(.one)
        let json = ["integer": tooLow]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: IntegerContainer<T>.self)

        XCTAssertNil(result.value)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "integer"], reason: .numericOverflow(value: tooLow.decimalValue, type: "\(T.self)"))])
    }

    private func performPrecisionTest<T: APIDecodable & FixedWidthInteger & Equatable>(on type: T.Type) {
        let notWhole = 12.5
        let json = ["integer": notWhole]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: IntegerContainer<T>.self)

        XCTAssertNil(result.value)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "integer"], reason: .lossOfPrecision(value: Decimal(notWhole), type: "\(T.self)"))])
    }
}
