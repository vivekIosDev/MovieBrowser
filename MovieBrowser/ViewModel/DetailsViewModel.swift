//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.

import UIKit

struct DetailsViewModel {
    
    let fileHandler: FileHandler
    let defaultsManager: UserDefaultsManager
    
    var movieDetails: BoxBind<MovieDetails?> = BoxBind(nil)
    var moviePosterImage: BoxBind<UIImage?> = BoxBind(nil)
    let movieId: Int
    let moviePosterPath: String
    
    init(movieId: Int, moviePosterPath: String, fileHandler: FileHandler, defaultsManager: UserDefaultsManager) {
        self.movieId = movieId
        self.moviePosterPath = moviePosterPath
        
        self.fileHandler = fileHandler
        self.defaultsManager = defaultsManager
        
        self.getMovieDetails()
        self.getMoviePoster()
    }
    
    // MARK:- functions for the viewModel
    func getMovieDetails() {
        let synopsisServiceRequest = SynopsisServiceRequest.init(movieId: "\(self.movieId)")
        let synopsisResponseHandler = SynopsisResponseHandler.init()
        let requestCall = HTTPRequestCall.init(HTTPRequest: synopsisServiceRequest, HTTPResponseHandler: synopsisResponseHandler)
        let executor = HTTPRequestExecuter.init()
        
        executor.makeRequest(call: requestCall) { (result) in
            if(result?.errorCode != 0)  {
                //    self.movieDetailVC.showAlert(title: "Error", message: result!.errorMessage)
            }
            else
            {
                guard let movies = result!.result as? MovieDetails  else { return }
                movieDetails.value = movies
            }
        }
    }
    
    
    func getMoviePoster() {
        if (fileHandler.checkIfFileExists(id: movieId)) {
            self.moviePosterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: self.movieId).path)
        } else {
            guard let url = URL(string: "\(Constant.baseURLImg)\(moviePosterPath)") else { return }
             self.downloadMoviePoster(from: url)
        }
    }
    
    func downloadMoviePoster(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.moviePosterImage.value = image
            }
        }.resume()
    }
}
