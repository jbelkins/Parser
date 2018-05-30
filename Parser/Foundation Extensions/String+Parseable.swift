//
//  String+Parseable.swift
//  Parser
//
//  Created by Josh Elkins on 2/5/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension String: Parseable {
    static var extraJSONTypes = [JSONElement]()
    public static var idKey: String? = nil
    public static var jsonType = JSONElement.string
}

