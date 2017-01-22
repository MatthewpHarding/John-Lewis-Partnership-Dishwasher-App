//
//  FeatureFactory.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

struct FeatureFactory {

    static func remoteProductAPI() -> RemoteProductAPI {
        
        let urlRequestExecuter = URLRequestManager()
        let jsonSerializer = JSONSerializationManager()
        let networking = NetworkingManager(urlRequestExecuter: urlRequestExecuter, jsonSerializer: jsonSerializer)
        
        let productParser = RemoteProductAPIParser()
        let apiKey = "Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"
        return RemoteProductAPI(productParser: productParser, networking: networking, apiKey: apiKey)
    }
}
