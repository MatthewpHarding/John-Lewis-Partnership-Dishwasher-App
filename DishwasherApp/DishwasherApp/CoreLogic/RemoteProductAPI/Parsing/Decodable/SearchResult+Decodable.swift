//
//  SearchResult+Decodable.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

extension SearchResult: Decodable {
    
    public static func decode(_ json: JSON) -> Decoded<SearchResult> {
        
        return curry(SearchResult.init)
            <^> json <|| "products"
            <*> json <| "results"
    }
    
}
