//
//  JSONSerializationManagerTests.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import XCTest
@testable import DishwasherApp

class JSONSerializationManagerTests: XCTestCase {
    
    func testDataWithArray() {
        let testArray = ["element1", "element2", "element3"]
        let jsonSerializationManager = JSONSerializationManager()
        
        let data: Data?
        do {
            data = try jsonSerializationManager.dataWithJSONObject(array: testArray)
        } catch {
            data = nil
        }
        
        guard let serializedData = data else {
            XCTFail("Could not serialize the data")
            return
        }
        
        let deserializedArray: [String]?
        do {
            deserializedArray = try jsonSerializationManager.jsonObjectWithData(data: serializedData) as? [String]
        } catch {
            deserializedArray = nil
        }
        
        guard let outputArray = deserializedArray else {
            XCTFail("Could not deserialize the data")
            return
        }
        
        XCTAssertEqual(outputArray[0], "element1")
        XCTAssertEqual(outputArray[1], "element2")
        XCTAssertEqual(outputArray[2], "element3")
    }
    
    func testDataWithDictionary() {
        let testDictionary = ["key1": "element1", "key2": "element2", "key3": "element3"]
        let jsonSerializationManager = JSONSerializationManager()
        
        let data: Data?
        do {
            data = try jsonSerializationManager.dataWithJSONObject(dictionary: testDictionary)
        } catch {
            data = nil
        }
        
        guard let serializedData = data else {
            XCTFail("Could not serialize the data")
            return
        }
        
        let deserializedDictionary: [String: String]?
        do {
            deserializedDictionary = try jsonSerializationManager.jsonObjectWithData(data: serializedData) as? [String: String]
        } catch {
            deserializedDictionary = nil
        }
        
        guard let outputDictionary = deserializedDictionary else {
            XCTFail("Could not deserialize the data")
            return
        }
        
        XCTAssertEqual(outputDictionary["key1"], "element1")
        XCTAssertEqual(outputDictionary["key2"], "element2")
        XCTAssertEqual(outputDictionary["key3"], "element3")
    }
}
