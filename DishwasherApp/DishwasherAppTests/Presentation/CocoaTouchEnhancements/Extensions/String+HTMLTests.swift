//
//  String+HTMLTests.swift
//  DishwasherApp
//
//  Created by Matt Harding on 25/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import XCTest
@testable import DishwasherApp

class String_HTMLTests: XCTestCase {
    
    func testStrippingHTML() {
        
        executeAndTest("success", with: "<strong>success</strong>")
        executeAndTest("success", with: "<p>success</P>")
        executeAndTest("success", with: "<!DOCTYPE html>success</html>")
        executeAndTest("success", with: "<title>success</title>")
        executeAndTest("success", with: "<body>success</body>")
        executeAndTest("success", with: "<!DOCTYPE html><html><head><title></title></head><body>success</body></html>")
        executeAndTest("success", with: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">success")
        
        executeAndTest("success", with: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">success")
        
    }
    
    private func executeAndTest(_ expected: String, with test: String) {
        
        XCTAssertEqual(test.removingHTMLFormatting(), expected)
    }
}
