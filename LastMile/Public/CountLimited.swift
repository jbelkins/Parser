//
//  CountLimited.swift
//  LastMile
//
//  Created by Josh Elkins on 2/11/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public struct CountLimited<Parseable> {
    let min: Int?
    let max: Int?
    let isMandatory: Bool

    public init(min: Int, max: Int, isMandatory: Bool = false) {
        self.min = min
        self.max = max
        self.isMandatory = isMandatory
    }

    public init(min: Int, isMandatory: Bool = false) {
        self.min = min
        max = nil
        self.isMandatory = isMandatory
    }

    public init(max: Int, isMandatory: Bool = false) {
        min = nil
        self.max = max
        self.isMandatory = isMandatory
    }

    public init(exactly: Int, isMandatory: Bool = false) {
        min = exactly
        max = exactly
        self.isMandatory = isMandatory
    }
}
