//
//  ProductDetail.swift
//  DishwasherApp
//
//  Created by Matt Harding on 23/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

struct ProductDetail {
    
    let title: String
    let price: Price
    let code: String
    let imageURLs: [URL]
    let information: String
    let specialOffer: String?
    let includedServices: [String]
    let features: [ProductFeature]
}

struct ProductFeature {
    
    let name: String
    let attributes: [ProductAttribute]
}

struct ProductAttribute {
    
    let identifier: String
    let name: String
    let value: String
}
