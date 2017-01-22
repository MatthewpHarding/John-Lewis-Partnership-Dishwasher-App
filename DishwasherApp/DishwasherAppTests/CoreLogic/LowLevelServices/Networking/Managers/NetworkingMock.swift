//
//  NetworkingMock.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation
@testable import DishwasherApp

struct NetworkingMock: Networking {
    
    let responseResult: Result<Any?, NetworkingError>
    
    func performHTTPURLRequest(url: URL, method: HTTPRequest.HTTPMethod, headers: [String: String]?, body: Data?, completion: @escaping (Result<Any?, NetworkingError>) -> Void) {
        
        completion(responseResult)
    }
}
