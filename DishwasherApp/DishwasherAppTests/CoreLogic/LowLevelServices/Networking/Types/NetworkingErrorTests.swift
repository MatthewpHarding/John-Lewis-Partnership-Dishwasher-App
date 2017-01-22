//
//  NetworkingErrorTests.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import XCTest
@testable import DishwasherApp

class NetworkingErrorTests: XCTestCase {
    
    func testNSURLErrorFailedToFindResource() {
        
        let errorCodes = [NSURLErrorDNSLookupFailed, NSURLErrorHTTPTooManyRedirects, NSURLErrorResourceUnavailable, NSURLErrorRedirectToNonExistentLocation]
        
        for errorCode in errorCodes {
            let urlError = NSError(domain: NSURLErrorDomain, code: errorCode, userInfo: nil)
            if case .failedToFindResource = NetworkingError(urlError: urlError) {
                continue
            }
            
            XCTFail("Failed to convert NSError")
        }
    }
    
    func testNSURLErrorDataConnection() {
        
        let errorCodes = [NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost, NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost, NSURLErrorSecureConnectionFailed, NSURLErrorCannotLoadFromNetwork, NSURLErrorInternationalRoamingOff, NSURLErrorCallIsActive, NSURLErrorDataNotAllowed, NSURLErrorTimedOut]
        
        for errorCode in errorCodes {
            let urlError = NSError(domain: NSURLErrorDomain, code: errorCode, userInfo: nil)
            if case .dataConnection = NetworkingError(urlError: urlError) {
                continue
            }
            
            XCTFail("Failed to convert NSError")
        }
    }
    
    func testNSURLErrorUnknown() {
        
        let urlError = NSError(domain: NSURLErrorDomain, code: Int.max, userInfo: nil)
        if case .unknown = NetworkingError(urlError: urlError) {
            // success
        } else {
            XCTFail("Failed to convert NSError")
        }
    }
    
}
