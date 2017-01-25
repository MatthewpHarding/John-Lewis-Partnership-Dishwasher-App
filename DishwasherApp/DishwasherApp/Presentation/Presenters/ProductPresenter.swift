//
//  ProductPresenter.swift
//  DishwasherApp
//
//  Created by Matt Harding on 25/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

struct ProductPresenter {
    
    let title: String
    let subTitle: String
    let imageUrl: URL
    
    init(product: Product) {
        
        title = product.title
        
        let price = product.price.now
        let currencyFormatter = NumberFormatter(internationalCurrencyCode: product.price.currency)
        let formattedCurrency = currencyFormatter.string(from: price)
        subTitle = formattedCurrency ?? price
        
        imageUrl = product.imageUrl
    }
}
