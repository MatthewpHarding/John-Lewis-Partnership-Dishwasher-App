//
//  URLRequestExecuterMock.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation
@testable import DishwasherApp

struct URLRequestExecuterMock: URLRequestExecution {
    
    let response: (Void) -> (Data?, URLResponse?, Error?)
    
    func executeURLRequest(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let generatedResponse = response()
        let data = generatedResponse.0
        let urlResponse = generatedResponse.1
        let error = generatedResponse.2
        completion(data, urlResponse, error)
    }
}
