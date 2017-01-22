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
    case deserializationFailure
    case networkingError (NetworkingError)
}

struct RemoteProductAPI {
    
    let productParser: ProductParser
    let networking: Networking
    let apiKey: String
   
    func search(for term: String, pageSize: Int = 20, completion: @escaping (Result<SearchResult, RemoteProductAPIError>) -> Void) {
        
        guard let url = URL(string: "https://api.johnlewis.com/v1/products/search?q=\(term)&key=\(apiKey)&pageSize=\(pageSize)") else {
            completion(.error(.couldNotProccessRequest))
            return
        }
        
        networking.performHTTPURLRequest(url: url, method: .get, headers: nil, body: nil) { result in
            switch result {
            case .success(let networkingResponse):
                if case let .success (searchResult) = self.productParser.parseSearchResult(from: networkingResponse) {
                    completion(.success(searchResult))
                    return
                }
                
                return completion(.error(.deserializationFailure))
                
            case .error(let networkingError):
                completion(.error(.networkingError(networkingError)))
            }
        }
    }
}

