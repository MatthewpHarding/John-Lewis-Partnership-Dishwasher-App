//
//  RemoteProductAPIParser.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation
import Argo

enum RemoteProductAPIParserError: Error {
    case deserializationFailure
}

struct RemoteProductAPIParser {
    
    func parseSearchResult(from jsonObject: Any) -> Result<SearchResult, RemoteProductAPIParserError> {
        
        let decodedResult: Decoded<SearchResult> = decode(jsonObject)
        
        switch decodedResult {
        case .success(let decodedValue):
            return .success(decodedValue)
            
        case .failure:
            return .error(.deserializationFailure)
        }
    }
    
}
