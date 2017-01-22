//
//  NetworkingManager.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

struct NetworkingManager: Networking {
 
    let urlRequestExecuter: URLRequestExecution
    let jsonSerializer: JSONSerializer
    
    func performHTTPURLRequest(url: URL, method: HTTPRequest.HTTPMethod, headers: [String: String]?, body: Data?, completion: @escaping (Result<Any?, NetworkingError>) -> Void) {
        
        guard let urlRequest = buildURLRequest(url: url, method: method, headers: headers, body: body) else {
            completion(.error(.cannotProcessRequest))
            return
        }
        
        urlRequestExecuter.executeURLRequest(urlRequest: urlRequest) {  (responseData: Data?, urlResponse: URLResponse?, error: Error?) in
            
            // handle networking errors
            if let urlError = error as? NSError {
                completion(.error(NetworkingError(urlError: urlError)))
                return
            }
            
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
            
            // inspect any recieved data
            switch self.deserialize(responseData, serializer: self.jsonSerializer) {
            case .success(let deserializedData):
                completion(.success(deserializedData))
                
            case .error:
                completion(.error(.jsonDeserializationFailure))
            }
        }
    }
    
    private func buildURLRequest(url: URL, method: HTTPRequest.HTTPMethod, headers: [String: String]?, body: Data?) -> URLRequest? {
        
        var request = URLRequest(url: url, timeoutInterval: 30)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        return request
    }
    
    private func deserialize(_ responseData: Data?, serializer: JSONSerializer) -> Result<Any?, SerializationError> {
        
        guard let data = responseData else {
            return .success(nil)
        }
        
        do {
            let jsonObject = try serializer.jsonObjectWithData(data: data)
            return .success(jsonObject)
        } catch {
            return .error(.deserializationFailure)
        }
    }
}
