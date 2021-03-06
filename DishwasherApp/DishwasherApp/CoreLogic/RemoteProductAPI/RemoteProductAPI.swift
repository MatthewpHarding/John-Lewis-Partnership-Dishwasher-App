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
        
        let searchTermQueryItem = URLQueryItem(name: "q", value: term)
        let apiKeyQueryItem = URLQueryItem(name: "key", value: apiKey)
        let pageSizeQueryItem = URLQueryItem(name: "pageSize", value: "\(pageSize)")
        
        var urlComponents = URLComponents(string: "https://api.johnlewis.com/v1/products/search")
        urlComponents?.queryItems = [searchTermQueryItem, apiKeyQueryItem, pageSizeQueryItem]
        
        guard let url = urlComponents?.url else {
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
    
    func getDetails(for productIdentifier: String, completion: @escaping (Result<ProductDetail, RemoteProductAPIError>) -> Void) {
     
        guard let baseURL = URL(string: "https://api.johnlewis.com/v1/products") else {
            completion(.error(.couldNotProccessRequest))
            return
        }
        
        let baseURLWithProductId = baseURL.appendingPathComponent(productIdentifier)
        let apiKeyQueryItem = URLQueryItem(name: "key", value: apiKey)
        var urlComponents = URLComponents(url: baseURLWithProductId, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [apiKeyQueryItem]
        
        guard let url = urlComponents?.url else {
            completion(.error(.couldNotProccessRequest))
            return
        }
        
        networking.performHTTPURLRequest(url: url, method: .get, headers: nil, body: nil) { result in
            switch result {
                
            case .success(let networkingResponse):
                if case let .success (productDetail) = self.productParser.parseProductDetail(from: networkingResponse) {
                    completion(.success(productDetail))
                    return
                }
                
                return completion(.error(.deserializationFailure))
                
            case .error(let networkingError):
                completion(.error(.networkingError(networkingError)))
            }
        }
    }
}
