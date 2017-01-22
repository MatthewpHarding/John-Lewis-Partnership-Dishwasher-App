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
    
    func testSuccessfulResult() {
        
        // force our response to a be a success
        let response: (Void) -> (Data?, URLResponse?, Error?) = {
            let url = URL(string:"https://api.johnlewis.com")!
            let httpURLResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
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
        
            switch result {
            case .success: break
                
            case .error:
                XCTFail("Networking Manager returned an incorrect result")
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
