//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//

import Foundation

protocol FileTaskDelegate {
    
    //progress in 0.0 to 1.0
    func onProgressChange(progress : Float)
    // Download Progress Change
    func onDownloadProgress(totalBytesWritten: Float)
    //path of downloaded file will be passed in path parameter
    func onDownloadCompletion(url : URL)
    // Error on download or upload progress
    func onError(error : Error)
    // Status on Response Received
    func onResponse(statusCode: Int)
    // Uploading files completed
    func onUploadCompletion()
    // Data recieved
    func onDataRecieved(data: Data)
}

class SessionDelegate : NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    private var taskDelegates : Dictionary<Int, FileTaskDelegate> = [:]
    
    public func addTaskDelegate(delegate : FileTaskDelegate, task : URLSessionTask){
        print("\n \(#function) Task \(task)")
        taskDelegates[task.taskIdentifier] = delegate
        //        print("--------------------------------------------")
        //        print(taskDelegates)
        //        print("--------------------------------------------")
    }
    
    public func removeTaskDelegate(task: URLSessionTask) {
        print("\n \(#function) Task \(task)")
        if taskDelegates.contains(where: {$0.key == task.taskIdentifier}) {
            taskDelegates.removeValue(forKey: task.taskIdentifier)
        }
    }
    
    private func getTaskDelegate(task : URLSessionTask) -> FileTaskDelegate?{
        return taskDelegates[task.taskIdentifier];
    }
    
    // MARK:- URLSessionDelegates
    // MARK: Downloads
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        print("\n \(#function) Task \(downloadTask)")
        //        print("*************URLSessionDelegates")
        //        print("Session Task")
        //        print(downloadTask)
        //        print("Original Request")
        //        print(downloadTask.originalRequest)
        //        print("***********************************")
        getTaskDelegate(task: downloadTask)?.onDownloadCompletion(url: location)
    }
    //
    //    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
    //    }
    
    // On Download progress change
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        //        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        //        getTaskDelegate(task: downloadTask)?.onProgressChange(progress: progress)
        //        print("\n \(#function) - \(totalBytesWritten) Task \(downloadTask)")
        getTaskDelegate(task: downloadTask)?.onDownloadProgress(totalBytesWritten: Float(totalBytesWritten))
        
    }
    
    // MARK: Upload
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        print("\n \(#function) Task \(task) withError:\(String(describing: error?.localizedDescription))")
        
        if let error = error {
            getTaskDelegate(task: task)?.onError(error: error)
        }
        //        else {
        //            let unkownError : NSError = NSError(domain: "Transmission", code: 100, userInfo: [NSLocalizedDescriptionKey: "Transmission failed. Unkown Error"])
        //            getTaskDelegate(task: task)?.onError(error: unkownError)
        //        }
    }
    
    // On upload progress change
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent:
        Int64, totalBytesExpectedToSend: Int64) {
        
        //        print("\n \(#function) Task \(task)")
        let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        getTaskDelegate(task: task)?.onProgressChange(progress: progress)
        if progress == 1 {
            getTaskDelegate(task: task)?.onUploadCompletion()
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        print("\n \(#function) Task \(dataTask)")
        getTaskDelegate(task: dataTask)?.onDataRecieved(data: data)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        print("\n \(#function) Task \(dataTask)")
        if let serviceResponse = response as? HTTPURLResponse {
            getTaskDelegate(task: dataTask)?.onResponse(statusCode: serviceResponse.statusCode)
        }
    }
}

