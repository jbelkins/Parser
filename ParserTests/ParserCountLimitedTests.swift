//
//  ParserCountLimitedTests.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/6/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import XCTest
import Parser


struct TestStruct {
    let arrayWithMin: [Int]
    let arrayWithMax: [Int]
    let arrayWithExact: [Int]
}


extension TestStruct: Parseable {
    static var idKey: String? = nil
    static var jsonType: JSONElement = .object

    init?(parser: Parser) {
        let arrayWithMin = parser["arrayWithMin"] --> CountLimited<[Int]>(min: 2, isMandatory: true)
        let arrayWithMax = parser["arrayWithMax"] --> CountLimited<[Int]>(max: 2, isMandatory: true)
        let arrayWithExact = parser["arrayWithExact"] --> CountLimited<[Int]>(exactly: 2, isMandatory: true)
        guard parser.succeeded else { return nil }
        self.init(arrayWithMin: arrayWithMin!, arrayWithMax: arrayWithMax!, arrayWithExact: arrayWithExact!)
    }
}


class ParserCountLimitedTests: XCTestCase {

    func testSucceedsWhenCountsAreSatisfied() {
        let jsonData = ["arrayWithMin": [1, 2], "arrayWithMax": [3, 4], "arrayWithExact": [5, 6]]
        let result = JSONParser.parse(json: jsonData, to: TestStruct.self)
        XCTAssertNotNil(result)
    }

    func testFailsWhenAMandatoryMinIsExceeded() {
        let jsonData = ["arrayWithMin": [1], "arrayWithMax": [3, 4], "arrayWithExact": [5, 6]]
        let (result, errors) = JSONParser.parse(json: jsonData, to: TestStruct.self)
        XCTAssertNil(result)
        XCTAssertEqual(errors.count, 1)
    }
}
