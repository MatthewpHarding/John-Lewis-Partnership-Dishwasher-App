//
//  URLRequestExecution.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

protocol URLRequestExecution {
    
    func executeURLRequest(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}
