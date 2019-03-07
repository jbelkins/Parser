//
//  APIDecodableIntegralType.swift
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

import Foundation


protocol APIDecodableInteger: APIDecodable, FixedWidthInteger {
    init?(exactly: NSNumber)
    var decimal: Decimal { get }
}


extension APIDecodableInteger {

    public init?(from decoder: APIDecoder) {
        guard let nsNumber = decoder.json as? NSNumber, !nsNumber.isBoolean else {
            let error = APIDecodeError(path: decoder.path, actual: decoder.key.jsonType)
            decoder.recordError(error)
            return nil
        }
        let decimal = nsNumber.decimalValue
        guard decimal <= Self.max.decimal, decimal >= Self.min.decimal else {
            let error = APIDecodeError(path: decoder.path, value: decimal, overflowedType: "\(Self.self)")
            decoder.recordError(error)
            return nil
        }
        guard let value = Self.init(exactly: nsNumber) else {
            let error = APIDecodeError(path: decoder.path, value: decimal, impreciseType: "\(Self.self)")
            decoder.recordError(error)
            return nil
        }
        self = value
    }
}
