//
//  ProductParserMock.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation
@testable import DishwasherApp

struct ProductParserMock: ProductParser {
    
    let responseResult: Result<SearchResult, ProductParserError>
    
    func parseSearchResult(from jsonObject: Any?) -> Result<SearchResult, ProductParserError>{
        return responseResult
    }
}
