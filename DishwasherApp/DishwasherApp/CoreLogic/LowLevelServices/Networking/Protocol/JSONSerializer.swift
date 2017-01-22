//
//  JSONSerializer.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

protocol JSONSerializer {
    
    func dataWithJSONObject(array: Array<Any>) throws -> Data
    func dataWithJSONObject(dictionary: Dictionary<String, Any>) throws -> Data
    
    func jsonObjectWithData(data: Data) throws -> Any
}
