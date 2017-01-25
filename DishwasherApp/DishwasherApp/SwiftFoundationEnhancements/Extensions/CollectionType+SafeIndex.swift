//
//  CollectionType+SafeIndex.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    
    subscript(safe index: Index) -> Generator.Element? {
        
        return indices.contains(index) ? self[index] : nil
    }
}
