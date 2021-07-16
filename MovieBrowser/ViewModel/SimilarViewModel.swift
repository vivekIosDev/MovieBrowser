//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//
import UIKit

struct SimilarViewModel {
    
    // MARK:- variables for the viewModel
    let fileHandler: FileHandler

    let imageUrlString: String
    let id: Int
    let movieName: String
    let movies: SimilarMovieResult

    var posterImage: BoxBind<UIImage?> = BoxBind(nil)
    
    // MARK:- initializer for the viewModel
    init(similarMovies: SimilarMovieResult?, handler: FileHandler = FileHandler()) {
        
        guard let similarMovie = similarMovies else {
            self.id = 0
            self.imageUrlString = ""
            self.movieName = ""
            self.movies = SimilarMovieResult(posterPath: "", title: "", video: false, id: 0, overview: "", releaseDate: "", adult: false, backdropPath: "", voteCount: 0, genreIDS: [], voteAverage: 0, originalLanguage: .en, originalTitle: "", popularity: 0)
            
            self.fileHandler = handler
            return
        }
    
        self.imageUrlString = similarMovie.posterPath ?? ""
        self.id = similarMovie.id ?? 0
        self.movieName = similarMovie.title ?? ""
        self.movies = similarMovie

        self.fileHandler = handler
        
        self.getMovieImage()
    }
    
    // MARK:- functions for the viewModel
    func getMovieImage() {
        if (fileHandler.checkIfFileExists(id: id)) {
            self.posterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: id).path)
        } else {
            guard let url = URL(string: "\(Constant.baseURLImg)\(imageUrlString)") else { return }
//            networkManager.downloadMoviePoster(url: url, id: self.id) { res, error in
//                if (error == .none) {
//                    self.posterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: id).path)
//                }
//            }
            
            self.downloadMovieImage(from: url)
            
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
                self.posterImage.value = image
        }.resume()
    }

}
