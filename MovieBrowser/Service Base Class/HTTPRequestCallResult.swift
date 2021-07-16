//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//
import UIKit

class HTTPRequestCallResult: NSObject {
    
    var result              : Any
    var resultDict          : [String : Any]
    var errorCode           : Int = 0
    var errorMessage        : String = ""
    var RequestStartTime    : Date
    var ResponseFinishTime  : Date
    
    override init(){
        
        self.result = String("Default Result") as Any
        self.resultDict = [:]
        //self.errorCode = 0
        self.errorMessage = String("Undefined Error")
        self.RequestStartTime = Date.init()
        self.ResponseFinishTime =  Date.init()
    }
    
    init(result: AnyObject, resultDict: [String:Any], errorCode: Int, errorMessage: String, RequestStartTime: Date, ResponseFinishTime: Date) {
        
        self.result = result
        self.resultDict = resultDict
        self.errorCode = errorCode
        self.errorMessage = errorMessage
        self.RequestStartTime = RequestStartTime
        self.ResponseFinishTime = ResponseFinishTime
        
    }
    
}
