//
//  RemoteProductAPIParser.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation
import Argo

struct RemoteProductAPIParser: ProductParser {
    
    func parseSearchResult(from jsonObject: Any?) -> Result<SearchResult, ProductParserError> {
        
        guard let json = jsonObject else {
            return .error(.deserializationFailure)
        }
        
        let decodedResult: Decoded<SearchResult> = decode(json)
        
        switch decodedResult {
        case .success(let decodedValue):
            return .success(decodedValue)
            
        case .failure:
            return .error(.deserializationFailure)
        }
    }
    
    func parseProductDetail(from jsonObject: Any?) -> Result<ProductDetail, ProductParserError> {
        
        guard let json = jsonObject else {
            return .error(.deserializationFailure)
        }
        
        let decodedResult: Decoded<ProductDetail> = decode(json)
        
        switch decodedResult {
        case .success(let decodedValue):
            return .success(decodedValue)
            
        case .failure:
            return .error(.deserializationFailure)
        }
    }
}
