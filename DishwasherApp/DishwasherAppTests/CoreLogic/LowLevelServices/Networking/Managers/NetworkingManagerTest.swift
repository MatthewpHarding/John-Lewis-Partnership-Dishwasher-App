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
    
    func testSuccessfulResults() {
        executeRequest(withStatusCode: 100, success: false)
        executeRequest(withStatusCode: 199, success: false)
        executeRequest(withStatusCode: 200, success: true)
        executeRequest(withStatusCode: 299, success: true)
        executeRequest(withStatusCode: 300, success: false)
        executeRequest(withStatusCode: 400, success: false)
        executeRequest(withStatusCode: 500, success: false)
    }
    
    func executeRequest(withStatusCode statusCode: Int, success: Bool) {
        
        // force our response to a be a success
        let response: (Void) -> (Data?, URLResponse?, Error?) = {
            let url = URL(string:"https://api.johnlewis.com")!
            let httpURLResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
            return (nil, httpURLResponse, nil)
        }
        
        // inject in a mock object to handle the actual request
        let urlRequestExecution = URLRequestExecuter(response: response)
        let networkingManager = NetworkingManager(urlRequestExecuter: urlRequestExecution)
        
        guard let url = URL(string: "https://api.johnlewis.com") else {
            XCTFail("Could not successfuly generate a URL")
            return
        }
        
        // ensure the networking manager returns a success
        networkingManager.performHTTPURLRequest(url: url, method: "GET", headers: nil, body: nil) { result in
        
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
