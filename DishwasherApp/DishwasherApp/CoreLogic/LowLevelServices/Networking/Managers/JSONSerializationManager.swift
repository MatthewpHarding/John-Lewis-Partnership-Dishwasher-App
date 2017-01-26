//
//  JSONSerializationManager.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

struct JSONSerializationManager: JSONSerializer {
    
    func dataWithJSONObject(array: Array<Any>) throws -> Data {
        
        return try JSONSerialization.data(withJSONObject: array, options: [])
    }
    
    func dataWithJSONObject(dictionary: Dictionary<String, Any>) throws -> Data {
        
        return try JSONSerialization.data(withJSONObject: dictionary, options: [])
    }
    
    func jsonObjectWithData(data: Data) throws -> Any {
        
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
}
