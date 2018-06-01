//
//  NodeParser+SingleValueContainer.swift
//  Parser
//
//  Created by Josh Elkins on 5/31/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension NodeParser: SingleValueDecodingContainer {
    
    public func decodeNil() -> Bool {
        guard let something = json else { return true }
        return something is NSNull
    }

    
}
