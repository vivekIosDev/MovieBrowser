//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//
import UIKit

// The DetailListViewModel are the ones that calls the APIs and provide the array data to the Viewcontrollers.
struct DetailListViewModel {
    
    enum ListType {
        case movieCast
        case similarMovies
        case movieReview
    }
    
    // MARK:- variable for the viewModel
    let defaultsManager: UserDefaultsManager
    let fileHandler: FileHandler
    
    // Limiting the actors count to 5, since the api doesn't support multiple ids, calling APIs without the limit, easily exahauts the 500 API call / month free limit of the site.
    let movieId: Int
    var offset: Int = 0
    var limit: Int = 5
    
    var prefetch: BoxBind<Bool> = BoxBind(false)
    var similarMovies: BoxBind<[SimilarViewModel]?> = BoxBind([SimilarViewModel](repeating: SimilarViewModel(similarMovies: nil), count: 5))
    var movieCredits: BoxBind<[MovieCastViewModel]?> = BoxBind([MovieCastViewModel](repeating: MovieCastViewModel(movieCast: nil), count: 5))
    var movieCrew: BoxBind<[MoviewCrewViewModel]?> = BoxBind([MoviewCrewViewModel](repeating: MoviewCrewViewModel(movieCrew: nil), count: 5))
    
    // MARK:- initializer for the viewModel
    init(movieId: Int = 0, handler: FileHandler, defaultsManager: UserDefaultsManager) {
        self.defaultsManager = defaultsManager
        self.fileHandler = handler
        self.movieId = movieId
        
        self.getSimilarMovies()
        self.getMovieCredits()
    }
    
    // MARK:- functions for the viewModel
    func getSimilarMovies() {
        let similarMovieServiceRequest = SimilarMovieServiceRequest.init(movieId: "\(self.movieId)")
        let similarMovieResponseHandler = SimilarMovieResponseHandler.init()
        let requestCall = HTTPRequestCall.init(HTTPRequest: similarMovieServiceRequest, HTTPResponseHandler: similarMovieResponseHandler)
        let executor = HTTPRequestExecuter.init()
        
        executor.makeRequest(call: requestCall) { (result) in
            if(result?.errorCode != 0)  {
                //    self.movieDetailVC.showAlert(title: "Error", message: result!.errorMessage)
            }
            else
            {
                if let movieListData = result?.result as? [SimilarMovieResult] {
                    self.similarMovies.value = movieListData.map { SimilarViewModel(similarMovies: $0)}
                }
            }
//            else
//            {
//                guard let movies = result!.result as? [SimilarViewModel] else { return }
//                similarMovies.value = movies
//            }
        }
        
        
        
//        networkManager.getSimilarMovies(movieId: movieId) { (res, apiError) in
//            guard let movies = res else { return }
//            similarMovies.value = movies.map( { SimilarViewModel(similarMovies: $0) })
//        }
    }
    
    func getMovieCredits() {
        
        let similarMovieServiceRequest = MovieCreditServiceReqest.init(movieId: "\(self.movieId)")
        let similarMovieResponseHandler = MovieCreditResponseHandler.init()
        let requestCall = HTTPRequestCall.init(HTTPRequest: similarMovieServiceRequest, HTTPResponseHandler: similarMovieResponseHandler)
        let executor = HTTPRequestExecuter.init()
        
        executor.makeRequest(call: requestCall) { (result) in
            if(result?.errorCode != 0)  {
                //    self.movieDetailVC.showAlert(title: "Error", message: result!.errorMessage)
            }
            else
            {
                guard let castList = result!.result as? MovieCredits else { return }
                guard let cast = castList.cast else { return }
                movieCredits.value = cast.map( { MovieCastViewModel(movieCast: $0) })
                
                guard let crewList = result!.result as? MovieCredits else { return }
                guard let crew = crewList.crew else { return }
                movieCrew.value = crew.map( { MoviewCrewViewModel(movieCrew: $0) })
            }
        }
        
        
//
//        networkManager.getCredits(movieId: movieId) { (res, apiError) in
//            guard let movies = res else { return }
//            movieCredits.value = movies.map( { MovieCastViewModel(movieCast: $0) })
//        }
    }
        
    // for displaying data
    func getCountForDisplay(type : ListType) -> Int {
        if type == .similarMovies {
            guard let actorViewModels =  self.similarMovies.value else { return 0 }
            return actorViewModels.count
        } else if type == .movieReview {
            guard let movieReviewViewModels =  self.movieCrew.value else { return 0 }
            return movieReviewViewModels.count
        } else {
            guard let actorViewModels =  self.movieCredits.value else { return 0 }
            return actorViewModels.count
        }
    }
    
    func prepareCellForDisplay(collectionView: UICollectionView, indexPath: IndexPath, type : ListType) -> UICollectionViewCell {
        if type == .similarMovies {
            guard let movieViewModels = self.similarMovies.value else { return UICollectionViewCell()}
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarCollectionViewCell.identifier(), for: indexPath) as? SimilarCollectionViewCell {
                cell.setupCell(viewModel: movieViewModels[indexPath.row])
                return cell
            }
        } else if type == .movieCast {
            guard let movieViewModels = self.movieCredits.value else { return UICollectionViewCell()}
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier(), for: indexPath) as? CastCollectionViewCell {
                cell.setupCellForCast(viewModel: movieViewModels[indexPath.row])
                return cell
            }
        } else {
            guard let movieViewModels = self.movieCrew.value else { return UICollectionViewCell()}
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier(), for: indexPath) as? CastCollectionViewCell {
                cell.setupCellForCrew(viewModel: movieViewModels[indexPath.row])
                return cell
            }
        }
        fatalError()
    }
}
