//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//

import UIKit

class HTTPRequestExecuter : NSObject {
    
    typealias ServiceResponseBlock = (_ result : HTTPRequestCallResult?) -> Void
    var notifyBlock : ServiceResponseBlock?
    var requestCall : HTTPRequestCall?
    var session : URLSession?
    
    override init() {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    public func makeRequest(call : HTTPRequestCall , completionHandler : @escaping ServiceResponseBlock) {
        
        self.notifyBlock = completionHandler
        //If busy notify callback with error
        //validate call parameter if invalid notify callback
        
        //keep call in member, this indicates executer is busy...
        requestCall = call
        
        //Make session task
        let sessionTask = createTask()
        
        //execute session task
        sessionTask.resume()
        
    }
    
    private func finish(result : HTTPRequestCallResult?) {
        //make call nil
        //notify block about finish
        self.notifyFinish(result: result)
        
    }
    
    private func notifyFinish(result : HTTPRequestCallResult?) {
        DispatchQueue.main.sync(execute: {() -> Void in
            
            if let block = self.notifyBlock{
                block(result)
            }})
    }
    
    // // Returns upload, download or data task
    private func createTask() -> URLSessionTask {
        
        // create download task if its download request
        // Otherwise it must be data task.
        //        if self.requestCall?.HTTPRequest is DownloadFileRequest {
        //            return createDownloadTask()
        //        }
        //        else {
        return createDataTask() //TODO::Need to handle file download scenario
        //        }
    }
    
    private func createDataTask() -> URLSessionTask {
        
        let  task : URLSessionTask = session!.dataTask(with: makeURLRequest(), completionHandler: {(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void in
            print("*******************************************")
            print("Response")
            
            //Parse data to json dictionary
            let handler : HTTPResponseHandler = (self.requestCall?.HTTPResponseHandler)!
            
            if (data != nil) && error == nil {
                //send  response
                let respo = response as? HTTPURLResponse
                handler.onReceivedResponse(statusCode: (respo?.statusCode)!, headers: ((response as? HTTPURLResponse)?.allHeaderFields)! as! Dictionary<String, Any>)
                
                print("Status Code \((respo?.statusCode)!)")
                
                // send Data
                handler.onReceivedData(data: data! as NSData)
            }
            //finish
            let result : HTTPRequestCallResult
            if (error != nil){
                result = handler.processedResultOnError(error: error! as NSError)
                print("Error: \(error ?? "" as! Error)")
            }
            else{
                result = handler.processedResultOnFinish()
                print("Result: \(result.result)")
            }
            print("*******************************************")
            self.finish(result: result)
        })
        return task
    }
    
    private func createDownloadTask() -> URLSessionTask {
        
        let  task : URLSessionTask = session!.downloadTask(with: self.makeURLRequest()) { (url, response, error) in
            //Parse data to json dictionary
            let handler : HTTPResponseHandler = (self.requestCall?.HTTPResponseHandler)!
            
            if (url != nil) && error == nil {
                //send  response
                let respo = response as? HTTPURLResponse
                handler.onReceivedResponse(statusCode: (respo?.statusCode)!, headers: ((response as? HTTPURLResponse)?.allHeaderFields)! as! Dictionary<String, Any>)
                
                print("Status Code \((respo?.statusCode)!)")
                
                // send Data
                handler.onDownloadComplete(url: url!)
            }
            //finish
            let result : HTTPRequestCallResult
            if (error != nil){
                result = handler.processedResultOnError(error: error! as NSError)
                print("Error: \(error ?? "" as! Error)")
            }
            else{
                result = handler.processedResultOnFinish()
                print("Result: \(result.result)")
            }
            print("*******************************************")
            self.finish(result: result)
        }
        return task
    }
    //    private func createDownloadTask() -> URLSessionTask {
    //        let task : URLSessionDownloadTask = session!.downloadTask(with: self.makeURLRequest(), completionHandler: {(_ url: URL?, _ response: URLResponse?, _ error: Error?) -> Void in
    //
    //        })
    //        return task
    //    }
    //
    //    private func createUploadTask() -> URLSessionTask {
    //        let task : URLSessionUploadTask = session!.uploadTask(with: self.makeUploadDownloadRequest(), from: self.makeUploadData())
    //
    //        return task
    //    }
    //
    
    private func makeURLRequest() -> URLRequest {
        
        print("*******************************************\n")
        print("Request\n")
        
        let request = NSMutableURLRequest()
        
        //Set URL
        request.url = requestCall?.HTTPRequest.url
        print("URL     : \(String(describing: request.url!))")
        
        // Set Headers
        for header: Any in (requestCall?.HTTPRequest.headers?.allKeys)! {
            request.setValue(requestCall?.HTTPRequest.headers?[header] as? String, forHTTPHeaderField: header as! String)
            print("Headers : \(requestCall?.HTTPRequest.headers?[header] as? String ?? "")")
        }
        
        //Set HTTP method
        request.httpMethod = (requestCall?.HTTPRequest.httpMethod)!
        print("Method  : \(request.httpMethod)")
        
        //Set body if found
        let body: Data? = requestCall?.HTTPRequest.body as Data?
        if body != nil {
            request.httpBody = body
            
            print("Body    : \(String(bytes: body!, encoding: String.Encoding.utf8) ?? "")")
        }
        print("*******************************************")
        return request as URLRequest
    }
    
    //    private func makeUploadDownloadRequest() -> URLRequest {
    //
    //        let request = NSMutableURLRequest()
    //        //Set URL
    //        request.url = requestCall?.HTTPRequest.url
    //        print("URL     : \(request.url?.path ?? "")")
    //
    //
    //        // Set Headers
    //        for header: Any in (requestCall?.HTTPRequest.headers?.allKeys)! {
    //            request.setValue(requestCall?.HTTPRequest.headers?[header] as? String, forHTTPHeaderField: header as! String)
    //            print("Headers : \(requestCall?.HTTPRequest.headers?[header] as? String ?? "")")
    //        }
    //
    //        //Set HTTP method
    //        request.httpMethod = (requestCall?.HTTPRequest.httpMethod)!
    //        print("Method  : \(request.httpMethod)")
    //
    //
    //        return request as URLRequest
    //    }
    
    private func makeUploadData() -> Data {
        
        var data = Data()
        if let uploadData = requestCall?.HTTPRequest.body {
            data = uploadData as Data
        }
        return data
    }
}

extension HTTPRequestExecuter : URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        //Parse data to json dictionary
        let handler : HTTPResponseHandler = (self.requestCall?.HTTPResponseHandler)!
        //finish
        let result : HTTPRequestCallResult
        if (error != nil){
            result = handler.processedResultOnError(error: error! as NSError)
            print("Error: \(error ?? "" as! Error)")
            self.finish(result: result)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        if let handler = self.requestCall?.HTTPResponseHandler {
            let uploadProgress : Double = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
            handler.uploadProgress(progress: uploadProgress)
            print("upload Progress \(uploadProgress * 100)")
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        //Parse data to json dictionary
        let handler : HTTPResponseHandler = (self.requestCall?.HTTPResponseHandler)!
        handler.onReceivedData(data: data as NSData)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        //Parse data to json dictionary
        let handler : HTTPResponseHandler = (self.requestCall?.HTTPResponseHandler)!
        
        //send  response
        let respo = response as? HTTPURLResponse
        handler.onReceivedResponse(statusCode: (respo?.statusCode)!, headers: ((response as? HTTPURLResponse)?.allHeaderFields)! as! Dictionary<String, Any>)
        
        print("Status Code \((respo?.statusCode)!)")
    }
}
