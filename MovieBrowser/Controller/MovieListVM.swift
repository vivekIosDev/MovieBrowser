//
//  MovieListVM.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//

import UIKit

class MovieListVM {
    
    weak var movieListVC: MovieListVC!
    
    var model : MovieListModel?
    
    //  var alertService = AlertService()
    init(movieListVC: MovieListVC) {
        self.movieListVC = movieListVC
        
        movieListVC.startLoading()
        self.getListOfMovies()
    }
    
    func getListOfMovies() {
        
        let movieListServiceRequest = MovieListServiceRequest.init()
        let movieListResponseHandler = MovieListResponseHandler.init()
        let requestCall = HTTPRequestCall.init(HTTPRequest: movieListServiceRequest, HTTPResponseHandler: movieListResponseHandler)
        let executor = HTTPRequestExecuter.init()
        
        executor.makeRequest(call: requestCall) { (result) in
            if(result?.errorCode != 0)  {
                self.movieListVC.showAlert(title: "Error", message: result!.errorMessage)
            }
            else
            {
                if let resultModel = result?.result as? MovieListModel{
                    self.model = resultModel
                    self.movieListVC.reloadData()
                    self.movieListVC.stopLoading()
                }
            }
        }
    }
    
    
    
    func getNumberOfSections() -> Int {
        return model?.results?.count ?? 0
    }
    
    func getNumberOfRows() -> Int {
        return 1
    }
    
    func getMovieDetail(index:Int) -> Results? {
        if let value = model?.results?[index] {
            return value
        }
        return nil
    }
}

//extension MovieListVM:AlertServiceDelegate{
//    func didGetAlertList(alertList: Array<Alert>) {
//        self.alertList = alertList
//        alertVC.reloadData()
//        alertVC.dismissSVProgressHUD()
//    }
//}

