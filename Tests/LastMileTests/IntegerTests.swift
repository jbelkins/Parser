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
    let integer1: T?
    let integer2: T?

    init?(from decoder: APIDecoder) {
        let integer1 = decoder["integer1"] --> T?.self
        let integer2 = decoder["integer2"] --> T?.self
        self.integer1 = integer1; self.integer2 = integer2
    }
}


class IntegerTests: XCTestCase {

    //  MARK: - Parsing from an in-range integer

    func testDecodesInRangeInt8()   { runInRangeTest(on: Int8.self) }
    func testDecodesInRangeInt16()  { runInRangeTest(on: Int16.self) }
    func testDecodesInRangeInt32()  { runInRangeTest(on: Int32.self) }
    func testDecodesInRangeInt64()  { runInRangeTest(on: Int64.self) }
    func testDecodesInRangeInt()    { runInRangeTest(on: Int.self) }
    func testDecodesInRangeUInt8()  { runInRangeTest(on: UInt8.self) }
    func testDecodesInRangeUInt16() { runInRangeTest(on: UInt16.self) }
    func testDecodesInRangeUInt32() { runInRangeTest(on: UInt32.self) }
    func testDecodesInRangeUInt64() { runInRangeTest(on: UInt64.self) }
    func testDecodesInRangeUInt()   { runInRangeTest(on: UInt.self) }

    // MARK: - Parsing from a whole decimal number

    func testDecodesWholeDecimalToInt8()   { runWholeDecimalTest(on: Int8.self) }
    func testDecodesWholeDecimalToInt16()  { runWholeDecimalTest(on: Int16.self) }
    func testDecodesWholeDecimalToInt32()  { runWholeDecimalTest(on: Int32.self) }
    func testDecodesWholeDecimalToInt64()  { runWholeDecimalTest(on: Int64.self) }
    func testDecodesWholeDecimalToInt()    { runWholeDecimalTest(on: Int.self) }
    func testDecodesWholeDecimalToUInt8()  { runWholeDecimalTest(on: UInt8.self) }
    func testDecodesWholeDecimalToUInt16() { runWholeDecimalTest(on: UInt16.self) }
    func testDecodesWholeDecimalToUInt32() { runWholeDecimalTest(on: UInt32.self) }
    func testDecodesWholeDecimalToUInt64() { runWholeDecimalTest(on: UInt64.self) }
    func testDecodesWholeDecimalToUInt()   { runWholeDecimalTest(on: UInt.self) }

    //  MARK: - Positive overflow errors

    func testErrorsOnAnInt8Overflow()  { runOverflowTest(on: Int8.self) }
    func testErrorsOnAnInt16Overflow() { runOverflowTest(on: Int16.self) }
    func testErrorsOnAnInt32Overflow() { runOverflowTest(on: Int32.self) }
    func testErrorsOnAnInt64Overflow() { runOverflowTest(on: Int64.self) }
    func testErrorsOnAnIntOverflow()   { runOverflowTest(on: Int.self) }
    func testErrorsOnAUInt8Overflow()  { runOverflowTest(on: UInt8.self) }
    func testErrorsOnAUInt16Overflow() { runOverflowTest(on: UInt16.self) }
    func testErrorsOnAUInt32Overflow() { runOverflowTest(on: UInt32.self) }
    func testErrorsOnAUInt64Overflow() { runOverflowTest(on: UInt64.self) }
    func testErrorsOnAUIntOverflow()   { runOverflowTest(on: UInt.self) }

    // MARK: - Negative overflow errors

    func testErrorsOnAnInt8NegativeOverflow()  { runNegativeOverflowTest(on: Int8.self) }
    func testErrorsOnAnInt16NegativeOverflow() { runNegativeOverflowTest(on: Int16.self) }
    func testErrorsOnAnInt32NegativeOverflow() { runNegativeOverflowTest(on: Int32.self) }
    func testErrorsOnAnInt64NegativeOverflow() { runNegativeOverflowTest(on: Int64.self) }
    func testErrorsOnAnIntNegativeOverflow()   { runNegativeOverflowTest(on: Int.self) }
    func testErrorsOnAUInt8NegativeOverflow()  { runNegativeOverflowTest(on: UInt8.self) }
    func testErrorsOnAUInt16NegativeOverflow() { runNegativeOverflowTest(on: UInt16.self) }
    func testErrorsOnAUInt32NegativeOverflow() { runNegativeOverflowTest(on: UInt32.self) }
    func testErrorsOnAUInt64NegativeOverflow() { runNegativeOverflowTest(on: UInt64.self) }
    func testErrorsOnAUIntNegativeOverflow()   { runNegativeOverflowTest(on: UInt.self) }

    // MARK: - Loss of precision errors

    func testErrorsOnInt8LossOfPrecision()   { runPrecisionTest(on: Int8.self) }
    func testErrorsOnInt16LossOfPrecision()  { runPrecisionTest(on: Int16.self) }
    func testErrorsOnInt32LossOfPrecision()  { runPrecisionTest(on: Int32.self) }
    func testErrorsOnInt64LossOfPrecision()  { runPrecisionTest(on: Int64.self) }
    func testErrorsOnIntLossOfPrecision()    { runPrecisionTest(on: Int.self) }
    func testErrorsOnUInt8LossOfPrecision()  { runPrecisionTest(on: UInt8.self) }
    func testErrorsOnUInt16LossOfPrecision() { runPrecisionTest(on: UInt16.self) }
    func testErrorsOnUInt32LossOfPrecision() { runPrecisionTest(on: UInt32.self) }
    func testErrorsOnUInt64LossOfPrecision() { runPrecisionTest(on: UInt64.self) }
    func testErrorsOnUIntLossOfPrecision()   { runPrecisionTest(on: UInt.self) }

    // MARK: - Boolean errors

    func testErrorsOnDecodingBoolToInt8()   { runBooleanTest(on: Int8.self) }
    func testErrorsOnDecodingBoolToInt16()  { runBooleanTest(on: Int16.self) }
    func testErrorsOnDecodingBoolToInt32()  { runBooleanTest(on: Int32.self) }
    func testErrorsOnDecodingBoolToInt64()  { runBooleanTest(on: Int64.self) }
    func testErrorsOnDecodingBoolToInt()    { runBooleanTest(on: Int.self) }
    func testErrorsOnDecodingBoolToUInt8()  { runBooleanTest(on: UInt8.self) }
    func testErrorsOnDecodingBoolToUInt16() { runBooleanTest(on: UInt16.self) }
    func testErrorsOnDecodingBoolToUInt32() { runBooleanTest(on: UInt32.self) }
    func testErrorsOnDecodingBoolToUInt64() { runBooleanTest(on: UInt64.self) }
    func testErrorsOnDecodingBoolToUInt()   { runBooleanTest(on: UInt.self) }

    // MARK: - Private methods

    private func runInRangeTest<T: APIDecodable & FixedWidthInteger & Equatable>(on type: T.Type) {
        let json = ["integer1": T.max, "integer2": T.min]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: IntegerContainer<T>.self)

        XCTAssertEqual(result.value?.integer1, T.max)
        XCTAssertEqual(result.value?.integer2, T.min)
        XCTAssertEqual(result.errors, [])
    }

    private func runWholeDecimalTest<T: APIDecodable & FixedWidthInteger & Equatable>(on type: T.Type) {
        let whole: T = 124
        let data = "{\"integer1\":\(whole).00}".data(using: .utf8)!
        let result = APIDataDecoder().decode(data: data, to: IntegerContainer<T>.self)

        XCTAssertEqual(result.value?.integer1, whole)
        XCTAssertEqual(result.errors, [])
    }

    private func runOverflowTest<T: APIDecodable & FixedWidthInteger & Equatable>(on type: T.Type) {
        let tooBig = NSDecimalNumber(string: "\(T.max)").adding(.one)
        let json = ["integer1": tooBig]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: IntegerContainer<T>.self)

        XCTAssertNil(result.value?.integer1)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "integer1"], reason: .numericOverflow(value: tooBig.decimalValue, type: "\(T.self)"))])
    }

    private func runNegativeOverflowTest<T: APIDecodable & FixedWidthInteger & Equatable>(on type: T.Type) {
        let tooLow = NSDecimalNumber(string: "\(T.min)").subtracting(.one)
        let json = ["integer1": tooLow]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: IntegerContainer<T>.self)

        XCTAssertNil(result.value?.integer1)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "integer1"], reason: .numericOverflow(value: tooLow.decimalValue, type: "\(T.self)"))])
    }

    private func runPrecisionTest<T: APIDecodable & FixedWidthInteger & Equatable>(on type: T.Type) {
        let notWhole = 12.5
        let json = ["integer1": notWhole]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: IntegerContainer<T>.self)

        XCTAssertNil(result.value?.integer1)
        XCTAssertEqual(result.errors, [APIDecodeError(path: ["root", "integer1"], reason: .lossOfPrecision(value: Decimal(notWhole), type: "\(T.self)"))])
    }

    private func runBooleanTest<T: APIDecodable & FixedWidthInteger & Equatable>(on type: T.Type) {
        let json = ["integer1": true, "integer2": false]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let result = APIDataDecoder().decode(data: data, to: IntegerContainer<T>.self)

        XCTAssertNil(result.value?.integer1)
        XCTAssertNil(result.value?.integer2)
        let error1 = APIDecodeError(path: ["root", "integer1"], reason: .unexpectedJSONType(actual: .boolean))
        let error2 = APIDecodeError(path: ["root", "integer2"], reason: .unexpectedJSONType(actual: .boolean))
        XCTAssertEqual(result.errors, [error1, error2])
    }
}
