//
//  RemoteProductAPITests.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import XCTest
@testable import DishwasherApp

// MARK:- Search

class RemoteProductAPITests: XCTestCase {
    
    func testSearchWithSuccessfulResponse() {
        
        let callbackExpectation = expectation(description: "RemoteProductAPI executeSearch")
        
        let product = testableProduct()
        let searchResult = SearchResult(products: [product], results: 30)
        
        let parserResponseResult: Result<SearchResult, ProductParserError> = .success(searchResult)
        let networkingResponseResult: Result<Any?, NetworkingError> = .success(nil)
        
        executeSearch(for: "Dishwasher", parserResult: parserResponseResult, networkingResult: networkingResponseResult) { result in
            switch result {
            case .success(let recievedSearchResult):
                XCTAssertEqual(searchResult.products.count, recievedSearchResult.products.count)
                XCTAssertEqual(searchResult.results, recievedSearchResult.results)
                
            case .error:
                XCTFail("Could not return search results from the Product API")
            }
            
            callbackExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.1) { error in
            if let error = error {
                XCTFail("Unit test timed out with error: \(error)")
            }
        }
    }

    func testSearchParsingError() {
        
        let callbackExpectation = expectation(description: "RemoteProductAPI executeSearch")
        
        // Generate Testable Search Result
        let parserResponseResult: Result<SearchResult, ProductParserError> = .error(.deserializationFailure)
        let networkingResponseResult: Result<Any?, NetworkingError> = .success(nil)
        
        executeSearch(for: "Dishwasher", parserResult: parserResponseResult, networkingResult: networkingResponseResult) { result in
            
            switch result {
            case .success:
                XCTFail("Remote Product API returned a successful response when an error was expected")
                
            case .error(let remoteProductAPIError):
                if case .deserializationFailure = remoteProductAPIError {
                    // success
                } else {
                    XCTFail("Remote Product API returned an incorrect error value")
                }
            }
            
            callbackExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.1) { error in
            if let error = error {
                XCTFail("Unit test timed out with error: \(error)")
            }
        }
    }
    
    // MARK- Search Terms
    
    func testSearchTerms() {
        
        executeAndTestSuccessfulSearch(for: "noSpaces")
        executeAndTestSuccessfulSearch(for: "with Space")
        executeAndTestSuccessfulSearch(for: " with s e v e r al Spaces ")
        executeAndTestSuccessfulSearch(for: "with/S/l/a/s/h/e/s/")
        executeAndTestSuccessfulSearch(for: "withBackward\\S\\l\\a\\s\\h\\e\\s\\")
        executeAndTestSuccessfulSearch(for: "±§@£$%^&*()_+=`~")
    }
    
    private func executeAndTestSuccessfulSearch(for term: String) {
        
        let callbackExpectation = expectation(description: "RemoteProductAPI executeSearch")
        
        let product = testableProduct()
        let searchResult = SearchResult(products: [product], results: 30)
        
        let parserResponseResult: Result<SearchResult, ProductParserError> = .success(searchResult)
        let networkingResponseResult: Result<Any?, NetworkingError> = .success(nil)
        
        executeSearch(for: term, parserResult: parserResponseResult, networkingResult: networkingResponseResult) { result in
            
            switch result {
            case .success: break
            case .error(let remoteProductAPIError):
                switch remoteProductAPIError {
                case .deserializationFailure, .networkingError:
                XCTFail("Could not return search results from the Product API")
                case .couldNotProccessRequest:
                    XCTFail("Could not process the search result term used for the Product API")
                }
            }
            
            callbackExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.1) { error in
            if let error = error {
                XCTFail("Unit test timed out with error: \(error)")
            }
        }
    }

    // MARK:- Helpers
    
    private func executeSearch(for term: String, parserResult: Result<SearchResult, ProductParserError>, networkingResult: Result<Any?, NetworkingError>, completion: @escaping (Result<SearchResult, RemoteProductAPIError>) -> Void) {
        
        let networking = NetworkingMock(responseResult: networkingResult)
       
        var productParser = ProductParserMock()
        productParser.searchResult = parserResult
        
        let apiKey = "testKey"
        let remoteProductAPI = RemoteProductAPI(productParser: productParser, networking: networking, apiKey: apiKey)
        
        remoteProductAPI.search(for: term, pageSize: 20) { result in
            completion(result)
        }
    }
    
    private func testableProduct() -> Product {
        
        let price = Price(now: "39.95", currency: "GBP")
        guard let imageURL = URL(string: "https://api.johnlewis.com/images/1") else {
            XCTFail("Could not successfuly generate a URL")
            fatalError()
        }
        return Product(identifier: "123456789", title: "testTitle", price: price, imageUrl: imageURL)
    }
}

// MARK:- Product Detail

extension RemoteProductAPITests {

    func testProductDetailWithSuccessfulResponse() {
        
        let callbackExpectation = expectation(description: "RemoteProductAPI getDetails")
        
        let productDetail = testableProductDetail()
        let parserResponseResult: Result<ProductDetail, ProductParserError> = .success(productDetail)
        let networkingResponseResult: Result<Any?, NetworkingError> = .success(nil)
        
        getDetails(for: "id123456789", parserResult: parserResponseResult, networkingResult: networkingResponseResult) { result in
            switch result {
                
            case .success(let recievedProductDetail):
                XCTAssertEqual(productDetail.title, recievedProductDetail.title)
                XCTAssertEqual(productDetail.code, recievedProductDetail.code)
                
            case .error:
                XCTFail("Could not return product details from the Product API")
            }
            
            callbackExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.1) { error in
            if let error = error {
                XCTFail("Unit test timed out with error: \(error)")
            }
        }
    }
    
    // MARK:- Helpers
    
    private func getDetails(for productIdentifier: String, parserResult: Result<ProductDetail, ProductParserError>, networkingResult: Result<Any?, NetworkingError>, completion: @escaping (Result<ProductDetail, RemoteProductAPIError>) -> Void) {
        
        let networking = NetworkingMock(responseResult: networkingResult)
        var productParser = ProductParserMock()
        productParser.productDetailResult = parserResult
        
        let apiKey = "testKey"
        let remoteProductAPI = RemoteProductAPI(productParser: productParser, networking: networking, apiKey: apiKey)
        
        remoteProductAPI.getDetails(for: productIdentifier) { result in
            completion(result)
        }
    }
    
    private func testableProductDetail() -> ProductDetail {
        
        let price = Price(now: "39.95", currency: "GBP")
        let productAttribute = ProductAttribute(identifier: "1a2b3c4d5e6f7", name: "Test Detail", value: "A x B x C")
        let feature = ProductFeature(name: "Test Feature", attributes: [productAttribute])
        
        guard let imageURL = URL(string: "https://api.johnlewis.com/images/1") else {
            XCTFail("Could not successfuly generate a URL")
            fatalError()
        }
        
        return ProductDetail(title: "Product DetailX", price: price, code: "zxcvbnm", imageURLs: [imageURL], information: "info here for product", specialOffer: "We have a special offer", includedServices: ["This is our guarantee"], features: [feature])
    }
}
