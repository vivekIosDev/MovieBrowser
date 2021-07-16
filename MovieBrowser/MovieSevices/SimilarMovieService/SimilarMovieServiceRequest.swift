//
//  SimilarMovieServiceRequest.swift
//  MovieBrowser
//
//  Created by Mac-6 on 15/07/21.
//

import Foundation

class SimilarMovieServiceRequest: HTTPRequest
{

    let movieId : String?
    
    init(movieId : String) {
        self.movieId = movieId
    }
    override var url : URL? {
        get{
          //  https://api.themoviedb.org/3/movie/508943/similar?api_key=3684dfb677b30f70e0d6c0797ba208bd
         //   https://api.themoviedb.org/3/movie
            let url = Constant.baseURL + self.movieId! + "/similar?api_key=\(Constant.APIKey)"
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
