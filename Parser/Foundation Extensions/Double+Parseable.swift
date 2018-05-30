//
//  Double+Parseable.swift
//  Parser
//
//  Created by Josh Elkins on 2/7/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension Double: Parseable {
    static var extraJSONTypes = [JSONElement.int]
    public static var idKey: String? = nil
    public static let jsonType = JSONElement.double
}
