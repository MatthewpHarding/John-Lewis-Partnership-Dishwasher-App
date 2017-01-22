//
//  RemoteProductAPIParserTests.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import XCTest
@testable import DishwasherApp

class RemoteProductAPIParserTests: XCTestCase  {
    
    func testProduct() {
        guard let jsonObject = generateJsonObject(filename: "SearchResult-Dishwasher") else {
            XCTFail("Could not deserialize the data from the json file")
            return
        }
        
        let parser = RemoteProductAPIParser()
        let parsingResult = parser.parseSearchResult(from: jsonObject)
        
        guard case .success(let searchResult) = parsingResult else {
            XCTFail("Parsing failed")
            return
        }
        
        XCTAssertEqual(searchResult.results, 139)
        XCTAssertEqual(searchResult.products.count, 20)
        guard let product = searchResult.products.first else {
            XCTFail("Could not retrieve product in search results")
            return
        }
        
        XCTAssertEqual(product.identifier, "1913470")
        XCTAssertEqual(product.title, "Bosch SMV53M40GB Fully Integrated Dishwasher")
        XCTAssertEqual(product.imageUrl.absoluteString, "//johnlewis.scene7.com/is/image/JohnLewis/234326372?")
        
        let price = product.price
        XCTAssertEqual(price.now, "449.00")
        XCTAssertEqual(price.currency, "GBP")
        
        
    }

    // MARK:- Helper Methods
    
    private func loadFile(filename: String, ofType: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        
        guard
            let path = bundle.path(forResource: filename, ofType: ofType)
            else {
                return nil
        }
        let url = URL(fileURLWithPath: path)
        
        let data: Data?
        do {
            data = try Data(contentsOf: url)
        }
        catch {
            data = nil
        }
        return data
    }
    
    private func generateJsonObject(filename: String) -> Any? {
        guard let data = loadFile(filename: filename, ofType: "json") else {
            XCTFail("Could not load the test json file")
            return nil
        }
        
        let jsonSerializationManager = JSONSerializationManager()
        let jsonObject: Any?
        do {
            jsonObject = try jsonSerializationManager.jsonObjectWithData(data: data)
        } catch {
            jsonObject = nil
        }
        
        return jsonObject
    }
    
}
