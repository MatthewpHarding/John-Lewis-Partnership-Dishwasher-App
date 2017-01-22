//
//  NetworkingManager.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

struct NetworkingManager {
 
    let urlRequestExecuter: URLRequestExecution
    
    func performHTTPURLRequest(url: URL, method: String, headers: [String: String]?, body: Data?, completion: @escaping (Result<Data?, NetworkingError>) -> Void) {
        
        guard let urlRequest = buildURLRequest(url: url, method: method, headers: headers, body: body) else {
            completion(.error(.cannotProcessRequest))
            return
        }
        
        urlRequestExecuter.executeURLRequest(urlRequest: urlRequest) {  (responseData: Data?, urlResponse: URLResponse?, error: Error?) in
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                completion(.error(.unknown))
                return
            }
            
            let rawStatusCode = httpResponse.statusCode
            guard HTTPStatusCodeDomain.isSuccessful(rawStatusCode: rawStatusCode) else {
                let statusCode = HTTPStatusCode(rawValue: rawStatusCode)
                completion(.error(.unsuccessfulHTTPStatusCode(statusCode)))
                return
            }
            
            completion(.success(responseData))
        }
    }
    
    private func buildURLRequest(url: URL, method: String, headers: [String: String]?, body: Data?) -> URLRequest? {
        
        var request = URLRequest(url: url, timeoutInterval: 30)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        return request
    }
}
