//
//  PersonTests.swift
//  LastMileTests
//
//  Created by Josh Elkins on 3/5/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import XCTest
import LastMile


// This test case demonstrates the example code discussed in the
// project's README.md file.


struct Person {
    let id: Int
    let firstName: String
    let lastName: String
    let phoneNumber: String?
    let height: Double?
}

extension Person: APIDecodable {

    // You can optionally set an idKey that identifies the resource
    // you are decoding from when generating decode errors.
    // If idKey is not specified for your type or there is no value
    // present for that key, an identifier will not be recorded in
    // your error.
    static var idKey: String? { return "person_id" }

    init?(from decoder: APIDecoder) {
        // 1a
        let id =          decoder["person_id"]    --> Int.self
        let firstName =   decoder["first_name"]   --> String.self
        let lastName =    decoder["last_name"]    --> String.self

        // 1b
        let phoneNumber = decoder["phone_number"] --> String?.self
        let height =      decoder["height"]       --> Double?.self

        // 2
        guard decoder.succeeded else { return nil }

        // 3
        self.init(id: id!, firstName: firstName!, lastName: lastName!, phoneNumber: phoneNumber, height: height)
    }
}


class PersonTests: XCTestCase {
    let jsonData = """
    {
        "person_id": 8675309,
        "first_name": "Mary",
        "last_name": "Smith",
        "phone_number": "(312) 555-1212",
        "height": "really tall"
    }
    """.data(using: .utf8)!

    func testDecodesAPersonWithDataFieldsFilled() {
        let decodeResult = APIDataDecoder().decode(data: jsonData, to: Person.self)

        guard let person = decodeResult.value else {
            XCTFail("Person instance did not properly decode")
            return
        }

        // We check each field on Person.  All fields are filled except
        // "height", which is nil because its value in the sample JSON
        // was unexpectedly a string instead of a number.
        XCTAssertEqual(person.id, 8675309)
        XCTAssertEqual(person.firstName, "Mary")
        XCTAssertEqual(person.lastName, "Smith")
        XCTAssertEqual(person.phoneNumber, "(312) 555-1212")
        XCTAssertNil(person.height)
    }

    func testGeneratesAParseErrorForTypeOfHeight() {

        // Here, a parse error will be generated
        let decodeResult = APIDataDecoder().decode(data: jsonData, to: Person.self)

        // We verify that the decoder successfully decoded a Person instance
        // from the JSON.  Note that even though an instance was successfully
        // constructed, there was a parse error indicating that something in
        // the JSON was not as expected.
        XCTAssertNotNil(decodeResult.value)

        // Now we get the error.  We expect that exactly one error will be
        // returned, which we will examine below.
        guard let decodeError = decodeResult.errors.first, decodeResult.errors.count == 1 else {
            XCTFail("Expected one error; actual count \(decodeResult.errors.count)")
            return
        }

        // The jsonPath property shows where in the JSON the error occurred.
        // jsonPath gives a simple description of how the decoder traversed,
        // starting at the root of the JSON, to get to the site of the error.
        XCTAssertEqual(decodeError.path.jsonPath, "root[\"height\"]")

        // The taggedJSONPath property adds in annotation of the Swift type
        // that was decoded or expected at each JSON node, and, if available,
        // the ID for the object at that node.
        XCTAssertEqual(decodeError.path.taggedJSONPath, "root(Person person_id=8675309) > \"height\"(Double)")

        // The reason for the error is encapsulated in a Swift enum that
        // summarizes the reason and has associated values describing the
        // specifics for this error.
        XCTAssertEqual(decodeError.reason, .unexpectedJSONType(actual: .string))
        XCTAssertEqual("\(decodeError.reason)", "Unexpectedly found a string")

        // You can also just get all the error info in one informative string:
        XCTAssertEqual("\(decodeError)", "root(Person person_id=8675309) > \"height\"(Double) : Unexpectedly found a string")
    }
}
