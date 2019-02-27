//
//  Bool+Parseable.swift
//  Parser
//
//  Created by Josh Elkins on 2/11/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension Bool: Parseable {
    public static let jsonTypes: Set<JSONElement> = [.bool]
}
