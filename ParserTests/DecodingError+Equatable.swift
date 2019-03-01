//
//  DecodingError+Equatable.swift
//  ParserTests
//
//  Created by Josh Elkins on 2/6/19.
//  Copyright © 2019 Parser. All rights reserved.
//

import Foundation
import Parser


extension DecodingError: Equatable {

    public static func ==(lhs: DecodingError, rhs: DecodingError) -> Bool {
        return lhs.errorDescription == rhs.errorDescription && lhs.failureReason == rhs.failureReason && lhs.helpAnchor == rhs.helpAnchor && lhs.localizedDescription == rhs.localizedDescription && lhs.recoverySuggestion == rhs.recoverySuggestion && areCasesEqual(lhs: lhs, rhs: rhs)
    }

    // Returns true if the error case and coding path match, false otherwise.
    public static func areCasesEqual(lhs: DecodingError, rhs: DecodingError) -> Bool {
        switch (lhs, rhs) {
        case (.dataCorrupted(let lhsContext), .dataCorrupted(let rhsContext)),
             (.keyNotFound(_, let lhsContext), .keyNotFound(_, let rhsContext)),
             (.typeMismatch(_, let lhsContext), .typeMismatch(_, let rhsContext)),
             (.valueNotFound(_, let lhsContext), .valueNotFound(_, let rhsContext)):
            return lhsContext.codingPath.isSamePath(as: rhsContext.codingPath)
        default: return false
        }
    }
}


fileprivate extension Array where Element == CodingKey {

    fileprivate func isSamePath(`as` other: [CodingKey]) -> Bool {
        guard count == other.count else { return false }
        for (lhs, rhs) in zip(self, other) {
            if !(lhs == rhs) { return false }
        }
        return true
    }
}

extension CodingKey {

    static func ==(lhs: CodingKey, rhs: CodingKey) -> Bool {
        return lhs.stringValue == rhs.stringValue && lhs.intValue == rhs.intValue
    }
}
