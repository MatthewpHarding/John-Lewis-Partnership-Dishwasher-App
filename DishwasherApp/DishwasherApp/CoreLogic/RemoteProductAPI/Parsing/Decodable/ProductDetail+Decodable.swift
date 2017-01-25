//
//  ProductDetail+Decodable.swift
//  DishwasherApp
//
//  Created by Matt Harding on 23/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

extension ProductDetail: Decodable {
    
    public static func decode(_ json: JSON) -> Decoded<ProductDetail> {
        
        // NOTE: A limitation of Swift and this library is the compiler bails out if there are too many parameters to a curried function. Therefore we must seperate these into several parts
        let firstSet = curry(ProductDetail.init)
            <^> json <| "title"
            <*> json <| "price"
            <*> json <| "code"
        
        let secondSet = firstSet
            <*> json <|| ["media", "images", "urls"]
            <*> json <| ["details", "productInformation"]
            <*> json <|? "displaySpecialOffer"
        
        return secondSet
            <*> json <|| ["additionalServices", "includedServices"]
            <*> json <|| ["details", "features"]
    }
}


extension ProductFeature: Decodable {
    
    public static func decode(_ json: JSON) -> Decoded<ProductFeature> {
        
        return curry(ProductFeature.init)
            <^> json <| "groupName"
            <*> json <|| "attributes"
    }
}

extension ProductAttribute: Decodable {
    
    public static func decode(_ json: JSON) -> Decoded<ProductAttribute> {
        
        return curry(ProductAttribute.init)
            <^> json <| "id"
            <*> json <| "name"
            <*> json <| "value"
    }
}
