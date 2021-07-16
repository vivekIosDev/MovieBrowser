//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//

import UIKit

class HTTPRequestCall: NSObject {
    
    var HTTPRequest: HTTPRequest
    var HTTPResponseHandler: HTTPResponseHandler
    
    init(HTTPRequest: HTTPRequest, HTTPResponseHandler: HTTPResponseHandler) {
        self.HTTPRequest = HTTPRequest
        self.HTTPResponseHandler = HTTPResponseHandler
    }
    
}
