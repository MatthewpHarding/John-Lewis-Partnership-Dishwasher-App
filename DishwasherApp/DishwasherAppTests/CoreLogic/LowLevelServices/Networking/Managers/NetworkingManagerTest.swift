//
//  NetworkingManagerTest.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import XCTest
@testable import DishwasherApp

class NetworkingManagerTest: XCTestCase {
    
    // MARK:- Result Enum
    
    func testSuccessfulResults() {
        executeAndTestRequest(withStatusCode: 100, success: false)
        executeAndTestRequest(withStatusCode: 199, success: false)
        executeAndTestRequest(withStatusCode: 200, success: true)
        executeAndTestRequest(withStatusCode: 299, success: true)
        executeAndTestRequest(withStatusCode: 300, success: false)
        executeAndTestRequest(withStatusCode: 400, success: false)
        executeAndTestRequest(withStatusCode: 500, success: false)
    }
    
    private func executeAndTestRequest(withStatusCode statusCode: Int, success: Bool) {
        
        executeRequest(responseBody: nil, statusCode: statusCode) { result in
        
            if case .success = result,
                success == false {
                XCTFail("Networking Manager returned a successful result when an unsuccessful result was expected")
                return
            }
            
            if case .error = result,
                success == true {
                XCTFail("Networking Manager returned an error when a successful result was expected")
            }
        }
    }
    
    // MARK:- Response Data
    
    func testDeserializedResponse() {
        
        let testResponse = ["key1": "element1", "key2": "element2", "key3": "element3"]
        executeRequest(responseBody: testResponse, statusCode: 200) { result in
            
            switch result {
            case .success(let deserializedResponse):
                guard let dictionary = deserializedResponse as? [String: String] else {
                    XCTFail("Networking Manager failed to deserialize the response")
                    return
                }
                XCTAssertEqual(dictionary, testResponse)
                
            case .error:
                XCTFail("Networking Manager returned an error when a successful result was expected")
            }
        }
    }
    
    // MARK:- Helpers
    
    private func executeRequest(responseBody: [String: String]?, statusCode: Int, completion: @escaping (Result<Any?, NetworkingError>) -> Void) {
        
        guard let url = URL(string: "https://api.johnlewis.com") else {
            XCTFail("Could not successfuly generate a URL")
            return
        }
        
        let jsonSerializationManager = JSONSerializationManager()
        let response: (Void) -> (Data?, URLResponse?, Error?) = {
            
            let httpURLResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
            
            let data: Data? = {
                guard let dictionary = responseBody else {
                    return nil
                }
                
                do {
                    let data = try jsonSerializationManager.dataWithJSONObject(dictionary: dictionary)
                    return data
                } catch {
                    XCTFail("Failed to serialize the intended response")
                    return nil
                }
            }()
            
            return (data, httpURLResponse, nil)
        }
        
        let urlRequestExecution = URLRequestExecuter(response: response)
        let serializer = JSONSerializationManager()
        let networkingManager = NetworkingManager(urlRequestExecuter: urlRequestExecution, jsonSerializer: serializer)
        
        networkingManager.performHTTPURLRequest(url: url, method: "GET", headers: nil, body: nil, completion : completion)
    }
}

struct URLRequestExecuter: URLRequestExecution {
    
    let response: (Void) -> (Data?, URLResponse?, Error?)
    
    func executeURLRequest(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let generatedResponse = response()
        let data = generatedResponse.0
        let urlResponse = generatedResponse.1
        let error = generatedResponse.2
        completion(data, urlResponse, error)
    }
    
}
