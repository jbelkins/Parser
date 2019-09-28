//
//  CollectionTests.swift
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

struct Element: Codable, Equatable {
    let id: Int
    let name: String

    static func random() -> Element {
        let id = Int(arc4random())
        let name = UUID().uuidString
        return Element(id: id, name: name)
    }
}

extension Element: APIDecodable {

    init?(from decoder: APIDecoder) {
        let id = decoder["id"] --> Int.self
        let name = decoder["name"] --> String.self
        guard decoder.succeeded else { return nil }
        self.init(id: id!, name: name!)
    }
}


class CollectionTests: XCTestCase {
    let arrayCount = 100
    let pairCount = 100
    var array: [Element]!
    var dict: [String: Element]!
    var arrayJSONData: Data!
    var dictJSONData: Data!

    func setupArray(count: Int) {
        array = [Element]()
        (0..<count).forEach { i in
            array.append(Element.random())
        }
        arrayJSONData = try! JSONEncoder().encode(array)
    }

    func setupDict(count: Int) {
        dict = [String: Element]()
        (0..<count).forEach { i in
            dict[UUID().uuidString] = Element.random()
        }
        dictJSONData = try! JSONEncoder().encode(dict)
    }

    // MARK: - Array performance tests

    func test_SwiftArray100() {
        setupArray(count: 100)
        measure {
            runSwiftArrayDecoderPerformanceTest(count: 100)
        }
    }

    func test_LastMileArray100() {
        setupArray(count: 100)
        measure {
            runLastMileArrayDecoderPerformanceTest(count: 100)
        }
    }

    func test_SwiftArray1000() {
        setupArray(count: 1000)
        measure {
            runSwiftArrayDecoderPerformanceTest(count: 1000)
        }
    }

    func test_LastMileArray1000() {
        setupArray(count: 1000)
        measure {
            runLastMileArrayDecoderPerformanceTest(count: 1000)
        }
    }

    func test_SwiftArray10000() {
        setupArray(count: 10000)
        measure {
            runSwiftArrayDecoderPerformanceTest(count: 10000)
        }
    }

    func test_LastMileArray10000() {
        setupArray(count: 10000)
        measure {
            runLastMileArrayDecoderPerformanceTest(count: 10000)
        }
    }

    private func runSwiftArrayDecoderPerformanceTest(count: Int) {
        var value: [Element]?
        var error: Error?
        do {
            value = try JSONDecoder().decode([Element].self, from: arrayJSONData)
        } catch let e {
            error = e
        }
        XCTAssertEqual(value, array)
        XCTAssertEqual(value?.count ?? -1, count)
        XCTAssertNil(error)
    }

    private func runLastMileArrayDecoderPerformanceTest(count: Int) {
        var value: [Element]?
        var errors: [APIDecodeError] = []
        let result = APIDataDecoder().decode(data: arrayJSONData, to: [Element].self)
        value = result.value
        errors = result.errors
        XCTAssertEqual(value, array)
        XCTAssertEqual(value?.count ?? -1, count)
        XCTAssertEqual(errors.count, 0)
    }

    // MARK: - Dictionary performance tests

    func test_SwiftDict100() {
        setupDict(count: 100)
        measure {
            runSwiftDictDecoderPerformanceTest(count: 100)
        }
    }

    func test_LastMileDict100() {
        setupDict(count: 100)
        measure {
            runLastMileDictDecoderPerformanceTest(count: 100)
        }
    }

    func test_SwiftDict1000() {
        setupDict(count: 1000)
        measure {
            runSwiftDictDecoderPerformanceTest(count: 1000)
        }
    }

    func test_LastMileDict1000() {
        setupDict(count: 1000)
        measure {
            runLastMileDictDecoderPerformanceTest(count: 1000)
        }
    }

    func test_SwiftDict10000() {
        setupDict(count: 10000)
        measure {
            runSwiftDictDecoderPerformanceTest(count: 10000)
        }
    }

    func test_LastMileDict10000() {
        setupDict(count: 10000)
        measure {
            runLastMileDictDecoderPerformanceTest(count: 10000)
        }
    }

    func runSwiftDictDecoderPerformanceTest(count: Int) {
        var value: [String: Element]?
        var error: Error?
        do {
            value = try JSONDecoder().decode([String: Element].self, from: dictJSONData)
        } catch let e {
            error = e
        }
        XCTAssertEqual(value, dict)
        XCTAssertEqual(value?.count ?? -1, count)
        XCTAssertNil(error)
    }

    func runLastMileDictDecoderPerformanceTest(count: Int) {
        var value: [String: Element]?
        var errors: [APIDecodeError] = []
        let result = APIDataDecoder().decode(data: dictJSONData, to: [String: Element].self)
        value = result.value
        errors = result.errors
        XCTAssertEqual(value, dict)
        XCTAssertEqual(value?.count ?? -1, count)
        XCTAssertEqual(errors.count, 0)
    }
}

