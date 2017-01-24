//
//  ProductDetailPresenter.swift
//  DishwasherApp
//
//  Created by Matt Harding on 24/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation


// Utilise a ghost protocol for type safety
protocol ProductDetailPresenter {
    
}

struct PriceInfoCellPresenter: ProductDetailPresenter {
    let title: String
    let priorityMessage: String?
    let description: String
    
    init(productDetail: ProductDetail) {
        title = productDetail.price.now
        priorityMessage = productDetail.specialOffer
        description = PriceInfoCellPresenter.descriptionText(from: productDetail.includedServices)
    }
    
    static private func descriptionText(from includedServices: [String]) -> String {
        
        let numberOfIncludedServices = includedServices.count
        var fullDescription: String = ""
        for (index, service) in includedServices.enumerated() {
            fullDescription.append(service)
            if index < numberOfIncludedServices - 1 {
                fullDescription.append("\n")
            }
        }
        return fullDescription
    }
}

struct TitleCellPresenter: ProductDetailPresenter {
    let title: String
}

struct DescriptionCellPresenter: ProductDetailPresenter {
    let text: String
    
    init(productDetail: ProductDetail) {
        text = productDetail.information
    }
}

struct ProductCodeCellPresenter: ProductDetailPresenter {
    let text: String
    
    init(productDetail: ProductDetail) {
        text = String(format: NSLocalizedString("Product code: %@", comment:""), productDetail.code)
    }
}

struct AttributeCellPresenter: ProductDetailPresenter {
    let leftText: String
    let rightText: String
    
    init(productAttribute: ProductAttribute) {
        leftText = productAttribute.name
        rightText = productAttribute.value
    }
}
