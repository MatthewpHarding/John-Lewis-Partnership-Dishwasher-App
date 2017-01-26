//
//  NSLocale+CurrencyTests.swift
//  DishwasherApp
//
//  Created by Matt Harding on 25/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import XCTest
@testable import DishwasherApp

class NSLocale_CurrencyTests: XCTestCase {
    
    func testInternationalCurrencyCode() {
        
        executeAndTest(internationalCurrencyCode: "GBP", expectedCurrencySymbol: "£")
        executeAndTest(internationalCurrencyCode: "USD", expectedCurrencySymbol: "US$")
        executeAndTest(internationalCurrencyCode: "AUD", expectedCurrencySymbol: "A$")
        executeAndTest(internationalCurrencyCode: "EUR", expectedCurrencySymbol: "€")
    }
    
    private func executeAndTest(internationalCurrencyCode: String, expectedCurrencySymbol: String) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.locale = NSLocale(internationalCurrencyCode: internationalCurrencyCode) as Locale
        XCTAssertEqual(numberFormatter.currencySymbol, expectedCurrencySymbol)
    }
}
