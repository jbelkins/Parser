//
//  APIDecodable.swift
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


public protocol APIDecodable {
    static var idKey: String? { get }
    static var alwaysSucceeds: Bool { get }
    var parseableElementCount: Int? { get }

    init?(from decoder: APIDecoder)
}


extension APIDecodable {
    public static var idKey: String? { return nil }
    public static var alwaysSucceeds: Bool { return false }
    public var parseableElementCount: Int? { return nil }

    static func id(from json: Any?) -> String? {
        guard let idKey = idKey, let jsonDictionary = json as? [String: Any] else { return nil }
        if let id = jsonDictionary[idKey] as? CustomStringConvertible {
            return "\(id)"
        }
        return nil
    }
}
