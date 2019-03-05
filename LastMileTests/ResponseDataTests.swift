//
//  ResponseDataTests.swift
//  ParserTests
//
//  Created by Josh Elkins on 3/1/19.
//  Copyright © 2019 Parser. All rights reserved.
//

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
