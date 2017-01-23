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
    
    var searchResult: Result<SearchResult, ProductParserError>? = nil
    var productDetailResult: Result<ProductDetail, ProductParserError>? = nil
    
    func parseSearchResult(from jsonObject: Any?) -> Result<SearchResult, ProductParserError>{
        guard let searchResult = self.searchResult else {
            return .error(.deserializationFailure)
        }
        return searchResult
    }
    
    func parseProductDetail(from jsonObject: Any?) -> Result<ProductDetail, ProductParserError> {
        guard let productDetailResult = self.productDetailResult else {
            return .error(.deserializationFailure)
        }
        return productDetailResult
    }
}
