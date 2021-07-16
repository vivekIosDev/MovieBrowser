//
//  MovieListService.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//

import UIKit

let baseURL = "https://api.themoviedb.org/3/movie/"
class MovieListServiceRequest: HTTPRequest
{

    override var url : URL? {
        get{
           let url = "https://api.themoviedb.org/3/movie/now_playing?api_key=cab5142b6dba8c87493d7b69ad0a272e&language=en-US&page=1"
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
             let token =  "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjYWI1MTQyYjZkYmE4Yzg3NDkzZDdiNjlhZDBhMjcyZSIsInN1YiI6IjYwZWU2ZDMzYTQ0ZDA5MDA4MWE3N2Q4ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.HTgAurtmurz-n0Xgwmi0IyupJpAiFlJmtQYZZkXfGM0"
            let headers : [String : String] = ["Content-Type"   : "application/json",
                                                   "Authorization"  :  "Token " + token ]
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
