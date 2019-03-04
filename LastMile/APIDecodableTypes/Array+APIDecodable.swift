//
//  Array+APIDecodable.swift
//  LastMile
//
//  Created by Josh Elkins on 5/29/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation

extension Array: APIDecodable where Element: APIDecodable {
    public var parseableElementCount: Int? { return count }

    public init?(from decoder: APIDecoder) {
        guard let jsonArray = decoder.json as? [Any] else {
            let error = APIDecodeError(path: decoder.nodePath, actual: decoder.node.castableJSONTypes)
            decoder.recordError(error)
            return nil
        }
        let uncompactedArray = jsonArray.indices.map { decoder[$0] --> Element.self }
        self = uncompactedArray.compactMap { $0 }
    }
}
