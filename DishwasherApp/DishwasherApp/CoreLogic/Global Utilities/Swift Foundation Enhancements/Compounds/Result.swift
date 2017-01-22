//
//  Result.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

enum Result<T, E: Error> {
    case Success(T)
    case Error(E)
}
