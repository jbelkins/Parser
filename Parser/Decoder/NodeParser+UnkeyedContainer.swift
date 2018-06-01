//
//  NodeParser+UnkeyedContainer.swift
//  Parser
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension NodeParser: UnkeyedDecodingContainer {
    public var count: Int? {
        guard let jsonArray = json as? [Any] else { return nil }
        return jsonArray.count
    }

    public var isAtEnd: Bool {
        return currentIndex >= count ?? 0
    }


    public func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        <#code#>
    }

    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        <#code#>
    }

    public func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        <#code#>
    }

    func nextCodingPath() -> [Key] {
        currentIndex += 1
        return codingPath + [Key(intValue: currentIndex)]
    }
}
