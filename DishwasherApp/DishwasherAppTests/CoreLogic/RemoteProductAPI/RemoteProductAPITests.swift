//
//  RemoteProductAPITests.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import XCTest
@testable import DishwasherApp

class RemoteProductAPITests: XCTestCase {
    
    func testSuccessfulResponse() {
        
        // Generate Testable Search Result
        let price = Price(now: "39.95", currency: "GBP")
        guard let imageURL = URL(string: "https://api.johnlewis.com/images/1") else {
            XCTFail("Could not successfuly generate a URL")
            return
        }
        let product = Product(identifier: "123456789", title: "testTitle", price: price, imageUrl: imageURL)
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
        }
    }

    func testParsingError() {
        
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
    
    func testSearchTerms() {
        
        executeAndTestSuccessfulSearch(for: "noSpaces")
        executeAndTestSuccessfulSearch(for: "with Space")
        executeAndTestSuccessfulSearch(for: " with s e v e r al Spaces ")
        executeAndTestSuccessfulSearch(for: "with/S/l/a/s/h/e/s/")
        executeAndTestSuccessfulSearch(for: "withBackward\\S\\l\\a\\s\\h\\e\\s\\")
        executeAndTestSuccessfulSearch(for: "±§@£$%^&*()_+=`~")
    }
    
    func executeAndTestSuccessfulSearch(for term: String) {
        
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
        }
    }

    // MARK:- Helpers
    
    private func executeSearch(for term: String, parserResult: Result<SearchResult, ProductParserError>, networkingResult: Result<Any?, NetworkingError>, completion: @escaping (Result<SearchResult, RemoteProductAPIError>) -> Void) {
        
        let networking = NetworkingMock(responseResult: networkingResult)
       
        let productParser = ProductParserMock(responseResult: parserResult)
        let apiKey = "testKey"
        let remoteProductAPI = RemoteProductAPI(productParser: productParser, networking: networking, apiKey: apiKey)
        
        remoteProductAPI.search(for: term, pageSize: 20) { result in
            completion(result)
        }
    }
    
}

