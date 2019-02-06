//
//  ObjectDecoderTests.swift
//  ParserTests
//
//  Created by Josh Elkins on 5/28/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation
import XCTest
import Parser


struct SampleCodableData: Codable, Equatable {
    let id: Int
    let name: String
    let address: String
    let intOrNot: Int?
    let stringOrNot: String?
    let itsTrue: Bool
    let itsFalse: Bool
    let boolOrNot: Bool?
    let numbahs: [Double]
    let valyews: [String: UInt8]
}


class ObjectDecoderTests: XCTestCase {

    func testDecodesANewInstance() {
        let jsonObject: [String : Any] = ["id": 123, "name": "xyz", "address": "abc", "intOrNot": NSNull(), "itsTrue": true, "itsFalse": false, "numbahs": [8, 6, 7, 5, 3, 0, 9], "valyews": ["wun": 1, "tyew": 2, "big": 255]]
        let expected = SampleCodableData(id: 123, name: "xyz", address: "abc", intOrNot: nil, stringOrNot: nil, itsTrue: true, itsFalse: false, boolOrNot: nil, numbahs: [8, 6, 7, 5, 3, 0, 9], valyews: ["wun": 1, "tyew": 2, "big": 255])
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])

        var applesActual: SampleCodableData?
        do {
            applesActual = try JSONDecoder().decode(SampleCodableData.self, from: jsonData)
        } catch let error {
            XCTFail("Threw error on decode: \(error)")
        }
        XCTAssertEqual(applesActual, expected)

        var actual: SampleCodableData?
        do {
            actual = try ObjectDecoder().decode(SampleCodableData.self, from: jsonData)
        } catch let error {
            XCTFail("Threw error on decode: \(error)")
        }
        XCTAssertEqual(actual, expected)
    }

    func testDoesNotDecodeANumberToBool() {
        struct HasABool: Codable {
            let boolValue: Bool
        }
        let jsonObject = ["boolValue": 1]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])

        // Apple's decoder
        do {
            let _ = try JSONDecoder().decode(HasABool.self, from: jsonData)
            XCTFail("Decode attempt should have thrown")
        } catch DecodingError.typeMismatch(_, _) {
            // Expected.  Allow test to finish & pass.
        } catch {
            XCTFail("Decode threw unexpected error")
        }

        // Our decoder
        do {
            let _ = try ObjectDecoder().decode(HasABool.self, from: jsonData)
            XCTFail("Decode attempt should have thrown")
        } catch DecodingError.typeMismatch(_, _) {
            // Expected.  Allow test to finish & pass.
        } catch {
            XCTFail("Decode threw unexpected error")
        }
    }
}


protocol DecodesJSON {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: DecodesJSON {}
extension ObjectDecoder: DecodesJSON {}
