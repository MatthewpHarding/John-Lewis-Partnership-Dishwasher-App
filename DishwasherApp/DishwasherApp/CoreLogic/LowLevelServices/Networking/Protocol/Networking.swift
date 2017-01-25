//
//  Networking.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

typealias NetworkingResponse = (Any?)
typealias NetworkResponseResult = (Result<NetworkingResponse, NetworkingError>)

protocol Networking {
    
    func performHTTPURLRequest(url: URL, method: HTTPMethod, headers: [String: String]?, body: Data?, completion: @escaping (NetworkResponseResult) -> Void)
}
