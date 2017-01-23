//
//  ProductParser.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

enum ProductParserError: Error {
    case deserializationFailure
}

protocol ProductParser {
    func parseSearchResult(from jsonObject: Any?) -> Result<SearchResult, ProductParserError>
    func parseProductDetail(from jsonObject: Any?) -> Result<ProductDetail, ProductParserError>
}
