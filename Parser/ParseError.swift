//
//  ParseError.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


public struct ParseError {
    public let path: [PathNode]
    public let message: String
}
