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


class ObjectDecoderTests: XCTestCase {

    func testDecodesANewInstance() {

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

        let jsonObject: [String : Any] = ["id": 123, "name": "xyz", "address": "abc", "intOrNot": NSNull(), "itsTrue": true, "itsFalse": false, "numbahs": [8, 6, 7, 5, 3, 0, 9], "valyews": ["wun": 1, "tyew": 2, "big": 255]]
        compareResults(inputObject: jsonObject, outputType: SampleCodableData.self)
    }

    func testDoesNotDecodeANumberToBool() {

        struct HasABool: Decodable, Equatable {
            let boolValue: Bool
        }

        let jsonObject = ["boolValue": 1]
        compareResults(inputObject: jsonObject, outputType: HasABool.self)
    }

    func testDoesNotDecodeTrueTo1() {

        struct HasAnInt: Decodable, Equatable {
            let intValue: Int
        }

        let jsonObject = ["intValue": true]
        compareResults(inputObject: jsonObject, outputType: HasAnInt.self)
    }

    private func compareResults<T: Decodable & Equatable>(inputObject: Any, outputType: T.Type) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: inputObject, options: [])
            let swiftParserResult = try parse(T.self, from: jsonData, using: JSONDecoder())
            let ourParserResult = try parse(T.self, from: jsonData, using: ObjectDecoder())
            XCTAssertEqual(ourParserResult, swiftParserResult)
        } catch let error {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }

    private func parse<T: Decodable & Equatable>(_ type: T.Type, from data: Data, using decoder: DecodesJSONDataToEquatable) throws -> DecodeResult<T> {
        do {
            let result = try decoder.decode(T.self, from: data)
            return DecodeResult.success(result)
        } catch let error as DecodingError {
            return DecodeResult.error(error)
        }
    }
}


enum DecodeResult<T: Decodable & Equatable>: Equatable {
    case success(T)
    case error(DecodingError)
}


protocol DecodesJSONDataToEquatable {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable & Equatable
}

extension JSONDecoder: DecodesJSONDataToEquatable {}
extension ObjectDecoder: DecodesJSONDataToEquatable {}
