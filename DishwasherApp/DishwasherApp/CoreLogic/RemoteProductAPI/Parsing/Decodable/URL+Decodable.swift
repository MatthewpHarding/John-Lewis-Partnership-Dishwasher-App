//
//  URL+Decodable.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation
import Argo

extension URL: Decodable {
    
    public static func decode(_ json: JSON) -> Decoded<URL> {
        switch(json) {
        case let .string(s):
            return .fromOptional(URL(string: s))
        default:
            return .typeMismatch(expected: "URL", actual: "\(json)")
        }
    }
}
