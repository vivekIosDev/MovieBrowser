//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//
import Foundation
import UIKit

struct MovieViewModel {
    
    let fileHandler: FileHandler
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    var moviePosterImage: BoxBind<UIImage?> = BoxBind(nil)
    var moviePosterUrl: URL {
        guard let url = URL(string: "\(Constant.baseURLImg)\(self.posterPath ?? "")") else { return URL(string: "")! }
        return url
    }
    
    // MARK:- initializer for the viewModel
    init(meta: MovieList?, handler: FileHandler = FileHandler()) {
        
        guard let meta = meta else {
            self.adult = false
            self.backdropPath = ""
            self.genreIDS = []
            self.id = 0
            self.originalLanguage = ""
            self.originalTitle = ""
            self.overview = ""
            self.popularity = 0
            self.posterPath = ""
            self.releaseDate = ""
            self.title = ""
            self.video = false
            self.voteAverage = 0
            self.voteCount = 0
            self.fileHandler = handler
            return
        }
        
        self.adult = meta.adult
        self.backdropPath = meta.backdropPath
        self.genreIDS = meta.genreIDS
        self.id = meta.id
        self.originalLanguage = meta.originalLanguage
        self.originalTitle = meta.originalTitle
        self.overview = meta.overview
        self.popularity = meta.popularity
        self.posterPath = meta.posterPath
        self.releaseDate = meta.releaseDate
        self.title = meta.title
        self.video = meta.video
        self.voteAverage = meta.voteAverage
        self.voteCount = meta.voteCount
        self.fileHandler = handler
        getMoviePoster()
    }
    
    func getMoviePoster() {
        if (fileHandler.checkIfFileExists(id: id ?? 0)) {
            self.moviePosterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: id ?? 0).path)
        } else {
//            networkManager.downloadMoviePoster(url: self.moviePosterUrl, id: id ?? 0) { res, error in
//                if (error == .none) {
//                    self.moviePosterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: id ?? 0).path)
//                }
//            }
            
            downloadMovieImage(from: self.moviePosterUrl)
            
            
        }
    }
    
    func downloadMovieImage(from url: URL) {
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
