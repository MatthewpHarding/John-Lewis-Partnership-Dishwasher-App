//
//  String+HTML.swift
//  DishwasherApp
//
//  Created by Matt Harding on 25/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

extension String {
    
    func removingHTMLFormatting() -> String {
        
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
