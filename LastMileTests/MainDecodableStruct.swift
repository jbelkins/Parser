//
//  DecodableStruct.swift
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


struct MainDecodableStruct: Equatable {
    let id: Int
    let name: String
    let subArray: [DecodableSubStruct]
    let null: NSNull
    let indexed: [String: DecodableSubStruct]
    let truthy: Bool
    let decodable: SwiftDecodableStruct

    let falsey: Bool?
    let decimal: Double?
    let description: String?
    var substruct: DecodableSubStruct?
}


extension MainDecodableStruct: APIDecodable {
    static let idKey: String? = "id"

    init?(from decoder: APIDecoder) {
        let id =          decoder["id"]            --> Int.self
        let name =        decoder["name"]          --> String.self
        let subArray =    decoder["substructs"]    --> CountLimited<[DecodableSubStruct]>(exactly: 2)
        let null =        decoder["null"]          --> NSNull.self
        let indexed =     decoder["indexed"]       --> [String: DecodableSubStruct].self
        let truthy =      decoder["truthy"]        --> Bool.self
        let decodable =   decoder["decodable"]     .decodeRequired(swiftDecodable: SwiftDecodableStruct.self)

        let falsey =      decoder["falsey"]        --> Bool?.self
        let decimal =     decoder["decimal"]       --> Double?.self
        let description = decoder["description"]   --> String?.self
        let substruct =   decoder["substruct"]     --> DecodableSubStruct?.self

        guard decoder.succeeded else { return nil }
        self.init(id: id!, name: name!, subArray: subArray!, null: null!, indexed: indexed!, truthy: truthy!, decodable: decodable!, falsey: falsey, decimal: decimal, description: description, substruct: substruct)
    }
}


func ==(lhs: MainDecodableStruct, rhs: MainDecodableStruct) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.description == rhs.description && lhs.substruct == rhs.substruct
}
