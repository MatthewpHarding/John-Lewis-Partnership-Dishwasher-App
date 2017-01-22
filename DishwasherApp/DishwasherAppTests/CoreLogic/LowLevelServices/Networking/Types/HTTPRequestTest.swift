//
//  HTTPRequestTest.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import XCTest
@testable import DishwasherApp

class HTTPRequestTest: XCTestCase {
    
    func testSuccessfulStatusCode() {
        XCTAssertFalse(HTTPStatusCodeDomain.isSuccessful(rawStatusCode:100))
        XCTAssertFalse(HTTPStatusCodeDomain.isSuccessful(rawStatusCode:199))
        
        XCTAssertTrue(HTTPStatusCodeDomain.isSuccessful(rawStatusCode:200))
        XCTAssertTrue(HTTPStatusCodeDomain.isSuccessful(rawStatusCode:299))
        
        XCTAssertFalse(HTTPStatusCodeDomain.isSuccessful(rawStatusCode:300))
        XCTAssertFalse(HTTPStatusCodeDomain.isSuccessful(rawStatusCode:400))
        XCTAssertFalse(HTTPStatusCodeDomain.isSuccessful(rawStatusCode:500))
    }
    
}
