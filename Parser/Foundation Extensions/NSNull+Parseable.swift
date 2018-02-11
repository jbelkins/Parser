//
//  NSNull+Parseable.swift
//  Parser
//
//  Created by Josh Elkins on 2/10/18.
//  Copyright © 2018 Parser. All rights reserved.
//

import Foundation


extension NSNull: JSONRawValueType {
    static var extraJSONTypes = [JSONElement]()
    public static var idKey: String? = nil
    public static let jsonType = JSONElement.null
}
