//
//  HTTPRequest.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import Foundation

// https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
enum HTTPStatusCode: Int {
    
    // 1XX Informational
    case informationContinue = 100
    case informationSwitchingProtocols = 101
    
    // 2XX Success
    case successOk = 200
    case successCreated = 201
    case successAccepted = 202
    case successNonAuthoritativeInformation = 203
    case successNoContent = 204
    case successResetContent = 205
    case successPartialContent = 206
    
    // 3XX Redirectional
    case redirectMultipleChoices = 300
    case redirectMovedPermanently = 301
    case redirectFound = 302
    case redirectSeeOther = 303
    case redirectNotModified = 304
    case redirectUseProxy = 305
    case redirectUnused = 306
    case redirectTemporary = 307
    
    // 4XX Client Error
    case clientErrorBadRequest = 400
    case clientErrorUnauthorized = 401
    case clientErrorPaymentRequired = 402
    case clientErrorForbidden = 403
    case clientErrorNotFound = 404
    case clientErrorMethodNotAllowed = 405
    case clientErrorNotAcceptable = 406
    case clientErrorProxyAuthenticationRequired = 407
    case clientErrorRequestTimeout = 408
    case clientErrorConflict = 409
    case clientErrorGone = 410
    case clientErrorLengthRequired = 411
    case clientErrorPreconditionFailed = 412
    case clientErrorEntityTooLarge = 413
    case clientErrorURITooLong = 414
    case clientErrorUnsupportedMediaType = 415
    case clientErrorRequestedRangeNotSatisfiable = 416
    case clientErrorExpectationFailed = 417
    
    // 5XX Server Error
    case serverInternalError = 500
    case serverNotImplemented = 501
    case serverBadGateway = 502
    case serverServiceUnavailable = 503
    case serverGatewayTimeout = 504
    case serverHTTPVersionNotSupported = 505
}

// https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
enum HTTPStatusCodeDomain: Int {
    
    case informational = 100
    case success = 200
    case redirectional = 300
    case clientError = 400
    case serverError = 500
    
    static func isSuccessful(rawStatusCode: Int) -> Bool {
        
        if rawStatusCode >= success.rawValue && rawStatusCode < redirectional.rawValue {
            return true
        }
        return false
    }
}

enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}
