//
//  NSLocale+Currency.swift
//  DishwasherApp
//
//  Created by Matt Harding on 25/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

extension NSLocale {
    
    convenience init(internationalCurrencyCode: String) {
        let localeIdentifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.currencyCode.rawValue : internationalCurrencyCode])
        self.init(localeIdentifier: localeIdentifier)
    }
}
