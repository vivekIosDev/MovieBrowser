//
//  MovieListService.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//

import UIKit

class MovieListServiceRequest: HTTPRequest
{

    override var url : URL? {
        get{
            let url = Constant.baseURL + "now_playing?api_key=\(Constant.APIKey)"
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
