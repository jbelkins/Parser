//
//  DecodingError+Equatable.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/6/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation


extension DecodingError: Equatable {

    // Returns true if the error case and coding path match, false otherwise.
    public static func ==(lhs: DecodingError, rhs: DecodingError) -> Bool {
        switch (lhs, rhs) {
        case (.dataCorrupted(let lhsContext), .dataCorrupted(let rhsContext)):
            return lhsContext.codingPath.isSamePath(as: rhsContext.codingPath)
        case (.keyNotFound(_, let lhsContext), .keyNotFound(_, let rhsContext)):
            return lhsContext.codingPath.isSamePath(as: rhsContext.codingPath)
        case (.typeMismatch(_, let lhsContext), .typeMismatch(_, let rhsContext)):
            return lhsContext.codingPath.isSamePath(as: rhsContext.codingPath)
        case (.valueNotFound(_, let lhsContext), .valueNotFound(_, let rhsContext)):
            return lhsContext.codingPath.isSamePath(as: rhsContext.codingPath)
        default: return false
        }
    }
}

fileprivate extension Array where Element == CodingKey {

    fileprivate func isSamePath(`as` other: [CodingKey]) -> Bool {
        guard count == other.count else { return false }
        for (lhs, rhs) in zip(self, other) {
            if lhs != rhs { return false }
        }
        return true
    }
}

fileprivate func ==(lhs: CodingKey, rhs: CodingKey) -> Bool {
    return lhs.stringValue == rhs.stringValue && lhs.intValue == rhs.intValue
}

fileprivate func !=(lhs: CodingKey, rhs: CodingKey) -> Bool {
    return !(lhs == rhs)
}
