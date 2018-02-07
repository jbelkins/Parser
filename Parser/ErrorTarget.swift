//
//  ErrorTarget.swift
//  Parser
//
//  Created by Josh Elkins on 2/7/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


protocol ErrorTarget: class {
    func receiveErrors(_ receivedErrors: [ParseError])
}
