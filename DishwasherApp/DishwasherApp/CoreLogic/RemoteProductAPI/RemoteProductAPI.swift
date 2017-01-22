//
//  RemoteProductAPI.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

enum RemoteProductAPIError: Error {
    case couldNotProccessRequest
    case networkingError (NetworkingError)
}

struct RemoteProductAPI {
    
    let networking: Networking
 
    func search(for term: String, completion: @escaping (Result<[Product], RemoteProductAPIError>) -> Void) {
        
        let apiKey = "Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"
        let pageSize = 20
        guard let url = URL(string: "https://api.johnlewis.com/v1/products/search?q=\(term)&key=\(apiKey)&pageSize=\(pageSize)") else {
            completion(.error(.couldNotProccessRequest))
            return
        }
        
        networking.performHTTPURLRequest(url: url, method: .get, headers: nil, body: nil) { result in
            switch result {
            case .success(let networkingResponse):
                // TODO parse the response and return an array of products
                break
            case .error(let networkingError):
                completion(.error(.networkingError(networkingError)))
            }
        }
    }
}
