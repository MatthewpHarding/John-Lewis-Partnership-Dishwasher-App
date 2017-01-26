//
//  ProductPresenterTests.swift
//  DishwasherApp
//
//  Created by Matt Harding on 25/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import XCTest
@testable import DishwasherApp

class ProductPresenterTests: XCTestCase {
    
    func testProductPresenter() {
        
        guard let product = testableProduct() else {
            XCTFail("Could not successfuly generate a Product to test")
            return
        }
        
        let productPresenter = ProductPresenter(product: product)
        
        XCTAssertEqual(productPresenter.title, "Fantastic new product")
        XCTAssertEqual(productPresenter.subTitle, "£\u{00A0}39.95")
        XCTAssertEqual(productPresenter.imageUrl.absoluteString, "https://api.johnlewis.com")
    }
    // MARK:- Helpers
    
    private func testableProduct() -> Product? {
        
        guard let imageUrl = URL(string: "https://api.johnlewis.com") else {
            XCTFail("Could not successfuly generate a URL")
            return nil
        }
        
        let price = Price(now: "39.95", currency: "GBP")
        return Product(identifier: "123456", title: "Fantastic new product", price: price, imageUrl: imageUrl)
    }
}
