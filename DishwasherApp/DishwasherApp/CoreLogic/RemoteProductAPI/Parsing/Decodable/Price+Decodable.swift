//
//  Price.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

extension Price: Decodable {
    
    public static func decode(_ json: JSON) -> Decoded<Price> {
        
        return curry(Price.init)
            <^> json <| "now"
            <*> json <| "currency"
    }
}
