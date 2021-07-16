//
//  MovieCreditServiceReqest.swift
//  MovieBrowser
//
//  Created by Mac-6 on 15/07/21.
//

import Foundation

class MovieCreditServiceReqest: HTTPRequest
{

    let movieId : String?
    
    init(movieId : String) {
        self.movieId = movieId
    }
    override var url : URL? {
        get{
            let url = Constant.baseURL + self.movieId! + "/credits?api_key=\(Constant.APIKey)"
             return URL(string : url)
        }
    }
    
    override var httpMethod : String? {
        get{
            return "GET"
        }
    }
    
    override var headers : NSDictionary? {
        get{
            let headers : [String : String] = ["Content-Type"   : "application/json",
                                               "Authorization"  :  "Token " + Constant.accessToken ]
                return headers as NSDictionary
//            }
        }
    }
    
    
    override var contentType : String? {
        get{
            return "application/json"
        }
    }
}

  
//
