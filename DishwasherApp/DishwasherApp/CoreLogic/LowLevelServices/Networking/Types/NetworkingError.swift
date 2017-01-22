//
//  NetworkingError.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case cannotProcessRequest
    case connectionFailure
    case unsuccessfulResponse
}
