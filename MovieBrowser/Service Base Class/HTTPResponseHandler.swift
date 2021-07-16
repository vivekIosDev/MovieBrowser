//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//

import UIKit

class HTTPResponseHandler: NSObject {
    
    var data : NSData?
    
    func onReceivedResponse(statusCode : Int, headers : Dictionary<String , Any> )-> Void {
    }
    
    public func onReceivedData(data : NSData) -> Void {
        self.data = data
    }
    
    public func onDownloadComplete(url: URL) -> Void {
        
    }
    
    public func processedResultOnError(error: NSError )-> HTTPRequestCallResult{
        
        let callResult = HTTPRequestCallResult()
        
        callResult.errorCode = error.code;
        callResult.errorMessage = error.localizedDescription
        return callResult
    }
    
    public func processedResultOnFinish()-> HTTPRequestCallResult{
        
        let callResult = HTTPRequestCallResult()
        return callResult
    }
    
    public func uploadProgress(progress: Double) -> Void {
        
    }
    
}
