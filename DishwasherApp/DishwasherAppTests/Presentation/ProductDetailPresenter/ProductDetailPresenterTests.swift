//
//  ProductDetailPresenterTests.swift
//  DishwasherApp
//
//  Created by Matt Harding on 24/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import XCTest
@testable import DishwasherApp

class ProductDetailPresenterTests: XCTestCase {
    
    func testPriceInfoCellPresenter() {
        let productDetail = testableProductDetail()
        
        let priceInfoCellPresenter = PriceInfoCellPresenter(productDetail: productDetail)
        XCTAssertEqual(priceInfoCellPresenter.title, "39.95")
        XCTAssertEqual(priceInfoCellPresenter.priorityMessage, "We have a special offer")
        XCTAssertEqual(priceInfoCellPresenter.description, "This is our guarantee\nThis is our second guarantee\nThis is our third guarantee")
    }
    
    func testDescriptionCellPresenter() {
        let productDetail = testableProductDetail()
        
        let descriptionCellPresenter = DescriptionCellPresenter(productDetail: productDetail)
        XCTAssertEqual(descriptionCellPresenter.text, "info here for product")
    }

    func testProductCodeCellPresenter() {
        let productDetail = testableProductDetail()
        
        let productCodeCellPresenter = ProductCodeCellPresenter(productDetail: productDetail)
        XCTAssertEqual(productCodeCellPresenter.text, "Product code: zxcvbnm")
    }

    func testAttributeCellPresenter() {
        let productDetail = testableProductDetail()
        
        guard let feature = productDetail.features.first else {
            XCTFail("Failed to find the desired number of Product Detail Features")
            return
        }
        
        guard
            let firstAttribute = feature.attributes[safe: 0],
            let secondAttribute = feature.attributes[safe: 1]
            else {
            XCTFail("Failed to find the desired number of Product Detail Attributes")
                return
        }
        
        let attributeCellPresenter = AttributeCellPresenter(productAttribute: firstAttribute)
        XCTAssertEqual(attributeCellPresenter.leftText, "Test Detail")
        XCTAssertEqual(attributeCellPresenter.rightText, "A x B x C")
        
        let secondAttributeCellPresenter = AttributeCellPresenter(productAttribute: secondAttribute)
        XCTAssertEqual(secondAttributeCellPresenter.leftText, "Some kind of valve")
        XCTAssertEqual(secondAttributeCellPresenter.rightText, "Check Valve 15mm")
    }
    
    // MARK:- Helpers
    
    private func testableProductDetail() -> ProductDetail {
        let price = Price(now: "39.95", currency: "GBP")
        let productAttribute = ProductAttribute(identifier: "1a2b3c4d5e6f7", name: "Test Detail", value: "A x B x C")
        let secondProductAttribute = ProductAttribute(identifier: "1a2b3c4d5e6f7", name: "Some kind of valve", value: "Check Valve 15mm")
        let feature = ProductFeature(name: "Test Feature", attributes: [productAttribute, secondProductAttribute])
        
        guard let imageURL = URL(string: "https://api.johnlewis.com/images/1") else {
            XCTFail("Could not successfuly generate a URL")
            fatalError()
        }
        
        return ProductDetail(title: "Product DetailX", price: price, code: "zxcvbnm", imageURLs: [imageURL], information: "info here for product", specialOffer: "We have a special offer", includedServices: ["This is our guarantee", "This is our second guarantee", "This is our third guarantee"], features: [feature])
    }
}
