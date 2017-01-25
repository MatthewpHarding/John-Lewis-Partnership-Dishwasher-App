//
//  NSFormatter+Currency.swift
//  DishwasherApp
//
//  Created by Matt Harding on 25/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

extension NumberFormatter {
    
    convenience init(internationalCurrencyCode: String) {
        self.init()
        numberStyle = NumberFormatter.Style.currency
        locale = NSLocale(internationalCurrencyCode: internationalCurrencyCode) as Locale
        var format = positiveFormat
        format = format?.replacingOccurrences(of: "¤", with: self.currencySymbol)
        positiveFormat = format
    }
    
    func string(from priceString: String) -> String? {
        let price = NSDecimalNumber(string: priceString)
        return string(from: price)
    }
}
