//
//  NSFormatter+CurrencyTests.swift
//  DishwasherApp
//
//  Created by Matt Harding on 25/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import XCTest
@testable import DishwasherApp

class NSFormatter_CurrencyTests: XCTestCase {

    func testInternationalCurrencyCode() {
        
        // \u{00A0} is a non breaking white space
        executeAndTestFormattedCurrency(internationalCurrencyCode:"GBP", input:"1.99", expected:"£\u{00A0}1.99")
        executeAndTestFormattedCurrency(internationalCurrencyCode:"GBP", input:"0.99", expected:"£\u{00A0}0.99")
        executeAndTestFormattedCurrency(internationalCurrencyCode:"GBP", input:"0.00", expected:"£\u{00A0}0.00")
        executeAndTestFormattedCurrency(internationalCurrencyCode:"GBP", input:"0.999999999", expected:"£\u{00A0}1.00")
        executeAndTestFormattedCurrency(internationalCurrencyCode:"GBP", input:"0.99111111", expected:"£\u{00A0}0.99")
        executeAndTestFormattedCurrency(internationalCurrencyCode:"GBP", input:"10000.00", expected:"£\u{00A0}10,000.00")
        executeAndTestFormattedCurrency(internationalCurrencyCode:"GBP", input:"100000.00", expected:"£\u{00A0}100,000.00")
        executeAndTestFormattedCurrency(internationalCurrencyCode:"GBP", input:"1000000.00", expected:"£\u{00A0}1,000,000.00")
        executeAndTestFormattedCurrency(internationalCurrencyCode:"GBP", input:"10000000.00", expected:"£\u{00A0}10,000,000.00")
        
        executeAndTestFormattedCurrency(internationalCurrencyCode:"GBP", input:"nonnumeric", expected:"NaN")
    }
    
    private func executeAndTestFormattedCurrency(internationalCurrencyCode: String, input: String, expected: String) {
        
        let currencyFormatter = NumberFormatter(internationalCurrencyCode: internationalCurrencyCode)
        XCTAssertEqual(currencyFormatter.string(from: input), expected)
    }

}
