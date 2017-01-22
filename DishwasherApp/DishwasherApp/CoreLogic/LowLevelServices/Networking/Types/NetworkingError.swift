//
//  NetworkingError.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

enum NetworkConnectivityError: Error {
    case failedToConnectToHost
    case noConnection
    case internationalRoamingOff
    case unsupportedWhileCallIsActive
    case dataNotAllowed
    case timedOut
}

enum NetworkingError: Error {
    case dataConnection (NetworkConnectivityError)
    case unsuccessfulHTTPStatusCode (HTTPStatusCode?)
    case failedToFindResource
    case unauthorized
    case jsonSerializationFailure
    case jsonDeserializationFailure
    case cannotProcessRequest
    case unknown
}

extension NetworkingError {
    
    init(urlError: Error) {
        self = NetworkingError.fromNSURLError(error: urlError)
    }
    
    private static func fromNSURLError(error: Error) -> NetworkingError {
        
        let cocoaTouchError = error as NSError
        
        if cocoaTouchError.domain == NSURLErrorDomain {
            switch cocoaTouchError.code {
                
            case NSURLErrorDNSLookupFailed,
                 NSURLErrorHTTPTooManyRedirects,
                 NSURLErrorResourceUnavailable,
                 NSURLErrorRedirectToNonExistentLocation:
                return .failedToFindResource
                
            case NSURLErrorCannotFindHost,
                 NSURLErrorCannotConnectToHost:
                return .dataConnection(.failedToConnectToHost)
                
            case NSURLErrorNotConnectedToInternet,
                 NSURLErrorNetworkConnectionLost,
                 NSURLErrorSecureConnectionFailed,
                 NSURLErrorCannotLoadFromNetwork:
                return .dataConnection(.noConnection)
                
            case NSURLErrorInternationalRoamingOff:
                return .dataConnection(.internationalRoamingOff)
                
            case NSURLErrorCallIsActive:
                return .dataConnection(.unsupportedWhileCallIsActive)
                
            case NSURLErrorDataNotAllowed:
                return .dataConnection(.dataNotAllowed)
                
            case NSURLErrorTimedOut:
                return .dataConnection(.timedOut)
                
            default:
                break
            }
        }
        
        return .unknown
    }
}
