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
        XCTAssertEqual(product.imageUrl.absoluteString, "https://johnlewis.scene7.com/is/image/JohnLewis/234326372?")
        
        let price = product.price
        XCTAssertEqual(price.now, "449.00")
        XCTAssertEqual(price.currency, "GBP")
    }

    func testProductDetail() {
        
        guard let jsonObject = generateJsonObject(filename: "ProductDetail-Dishwasher") else {
            XCTFail("Could not deserialize the data from the json file")
            return
        }
        
        let parser = RemoteProductAPIParser()
        let parsingResult = parser.parseProductDetail(from: jsonObject)
        
        guard case .success(let productDetail) = parsingResult else {
            XCTFail("Parsing failed")
            return
        }
        
        XCTAssertEqual(productDetail.title, "Bosch SMV53M40GB Fully Integrated Dishwasher")
        XCTAssertEqual(productDetail.code, "88701205")
        XCTAssertEqual(productDetail.information, "Please note: The door panel shown is for illustration purposes only and is not included. Your kitchen supplier will be able to supply a door panel for this appliance to match your kitchen units.\r\nThis Bosch SMV53M40GB integrated dishwasher boasts an impressive A++ energy rating for an economical and environmentally friendly home.\r\nA heat exchanger is used for hygienic and efficient drying, while salt and rinse aid indicators give you feedback. This economical machine makes dishwashing easy and convenient in any household.\r\nEcoSilence Drive&trade;\r\nBecause this machine is super quiet, you can take full advantage of off-peak energy costs without being disturbed during the night by noisy dishwashing. A brushless motor provides a quieter, faster and more energy efficient performance\r\nVarioSpeed Plus\r\nThis function cleans dishes up to three times faster, while providing the best possible cleaning and drying results.\r\nAquaMix\r\nThis glass protection system ensures extra gentle handling for your delicate glasses, making sure they come out shiny and clean without getting broken.")
        XCTAssertEqual(productDetail.specialOffer, "Save £50 until 07.02.17 (saving applied)")
        XCTAssertEqual(productDetail.imageURLs.count, 6)
        XCTAssertEqual(productDetail.includedServices.count, 1)
        XCTAssertEqual(productDetail.features.count, 1)
        
        guard let feature = productDetail.features.first else {
            XCTFail("Could not retrieve feature in product details")
            return
        }
        
        XCTAssertEqual(feature.name, "")
        XCTAssertEqual(feature.attributes.count, 27)
        
        guard let attribute = feature.attributes.first else {
            XCTFail("Could not retrieve attribute in product details feature")
            return
        }
        
        XCTAssertEqual(attribute.identifier, "attr9834441113")
        XCTAssertEqual(attribute.name, "Dimensions")
        XCTAssertEqual(attribute.value, "H81.5 x W59.8 x D55cm")
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
