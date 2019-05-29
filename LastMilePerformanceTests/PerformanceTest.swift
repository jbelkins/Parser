//
//  PerformanceTest.swift
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

struct Element: Codable {
    let id: Int
    let name: String
    let pairs: [String: String]

    static func random() -> Element {
        let id = Int(arc4random())
        let name = UUID().uuidString
        var pairs = Dictionary<String, String>(minimumCapacity: 100)
        (0..<100).forEach { _ in
            pairs[UUID().uuidString] = UUID().uuidString
        }
        return Element(id: id, name: name, pairs: pairs)
    }
}

extension Element: APIDecodable {

    init?(from decoder: APIDecoder) {
        let id = decoder["id"] --> Int.self
        let name = decoder["name"] --> String.self
        let pairs = decoder["pairs"] --> [String: String].self
        guard decoder.succeeded else { return nil }
        self.init(id: id!, name: name!, pairs: pairs!)
    }
}


class PerformanceTest: XCTestCase {
    var jsonData: Data!

    override func setUp() {
        super.setUp()
        var elements = [Element]()
        (0..<100).forEach { i in
            elements.append(Element.random())
        }
        jsonData = try! JSONEncoder().encode(elements)
    }

    func testSwiftDecoderPerformance() {
        self.measure {
            let _ = try! JSONDecoder().decode([Element].self, from: jsonData)
        }
    }

    func testLastMileDecoderPerformance() {
        self.measure {
            let _ = APIDataDecoder().decode(data: jsonData, to: [Element].self)
        }
    }

}
