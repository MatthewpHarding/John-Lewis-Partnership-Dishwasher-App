//
//  Product+Decodable.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

extension Product: Decodable {
    
    public static func decode(_ json: JSON) -> Decoded<Product> {
        
        // NOTE: A limitation of Swift and this library is the compiler bails out if there are too many parameters to a curried function. Therefore we must seperate these into several parts
        let firstSet = curry(Product.init)
            <^> json <| "productId"
            <*> json <| "title"
            <*> json <| "price"
        
        return firstSet
            <*> json <| "image"
    }
    
}
