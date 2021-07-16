//
//  MovieListResponseHandler.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//

import UIKit

class MovieListResponseHandler: HTTPResponseHandler
{
    static let shared = MovieListServiceRequest()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func processedResultOnFinish() -> HTTPRequestCallResult
    {
        let callResult = HTTPRequestCallResult()
        
        if let data = self.data {
            do {
                let json : [String : Any] = try JSONSerialization.jsonObject(with: Data.init(referencing: data), options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String : Any]
                
                let model = try MovieListModel.init(from: json)
     
                print(model.results?.first?.title)
              
                
                callResult.result = model
            }catch {
                callResult.errorMessage = error.localizedDescription
            }
        }
        callResult.ResponseFinishTime = Date.init()
        
        return callResult
    }
}
