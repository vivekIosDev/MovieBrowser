//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//
import Foundation
import UIKit

struct MovieReviewViewModel {
    
    // MARK:- variables for the viewModel
    let fileHandler: FileHandler
    
    let imageUrlString: String
    let id: String
    let authorName: String
    let movieReview: MovieReviews
    
    var posterImage: BoxBind<UIImage?> = BoxBind(nil)
    
    // MARK:- initializer for the viewModel
    init(movieReviews: MovieReviews?, handler: FileHandler = FileHandler()) {
        guard let movieReviews = movieReviews else {
            self.id = ""
            self.imageUrlString = ""
            self.authorName = ""
            self.movieReview = MovieReviews(author: "", authorDetails: AuthorDetails(name: "", username: "", avatarPath: "", rating: 0), content: "", createdAt: "", id: "", updatedAt: "", url: "")
            self.fileHandler = handler
            return
        }
        
        self.imageUrlString = movieReviews.authorDetails?.avatarPath ?? ""
        self.id = movieReviews.id ?? ""
        self.authorName = movieReviews.author ?? ""
        self.movieReview = movieReviews
        self.fileHandler = handler
        self.getMovieImage()
    }
    
    // MARK:- functions for the viewModel
    func getMovieImage() {
        if (fileHandler.checkIfFileExists(id: Int(id) ?? 0)) {
            self.posterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: Int(id) ?? 0).path)
        } else {
            guard let url = URL(string: "\(Constant.baseURLImg)\(imageUrlString)") else { return }
//            networkManager.downloadMoviePoster(url: url, id: Int(id) ?? 0) { res, error in
//                if (error == .none) {
//                    self.posterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: Int(id) ?? 0).path)
//                }
//            }
            
            downloadMoviePoster(from: url)
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
                self.posterImage.value = image
            }
        }.resume()
    }
}
