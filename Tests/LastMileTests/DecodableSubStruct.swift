//
//  DecodableSubStruct.swift
//  LastMile
//
//  Copyright (c) 2018 Josh Elkins
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

import Foundation
import LastMile


struct DecodableSubStruct: Equatable {
    let identifier: String
}


extension DecodableSubStruct: APIDecodable {
    static var idKey: String? = "identifier"

    init?(from decoder: APIDecoder) {
        let identifier = decoder["identifier"] --> String.self
        guard decoder.succeeded else { return nil }
        self.init(identifier: identifier!)
    }
}


func ==(lhs: DecodableSubStruct, rhs: DecodableSubStruct) -> Bool {
    return lhs.identifier == rhs.identifier
}
