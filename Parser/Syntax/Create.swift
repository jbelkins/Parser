//
//  Create.swift
//  Parser
//
//  Created by Josh Elkins on 2/11/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public struct Create<TargetType> {
    let min: Int?
    let max: Int?

    public init(max: Int? = nil, min: Int? = nil) {
        self.min = min
        self.max = max
    }
}
