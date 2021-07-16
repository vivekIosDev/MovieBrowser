//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//
import Foundation
import UIKit

struct HomeViewModel {
    
    
    
    // Enum for Table View List Type like Search & normal list
    enum TableType {
        case nowPlaying
        case search
        case recentSearch
    }
    
    //MARK: Variable
    var nowPlayingMovies: BoxBind<[MovieViewModel]?> = BoxBind([MovieViewModel](repeating: MovieViewModel(meta: nil), count: 5))
    var filteredMovies: BoxBind<[MovieViewModel]?> = BoxBind([MovieViewModel](repeating: MovieViewModel(meta: nil), count: 0))
    
    public var defaultsManager: UserDefaultsManager
    public var recentlySearchedMovies = [MovieList]()
 

    //MARK: Init
    init(defaultsManager: UserDefaultsManager) {
        self.defaultsManager = defaultsManager
        
        self.getNowPlayingMovies()
        self.getRecentSearchedMovies()
    }
    
    //MARK: API Call to Get List of Movies
    func getNowPlayingMovies() {
        let movieListServiceRequest = MovieListServiceRequest.init()
        let movieListResponseHandler = MovieListResponseHandler.init()
        let requestCall = HTTPRequestCall.init(HTTPRequest: movieListServiceRequest, HTTPResponseHandler: movieListResponseHandler)
        let executor = HTTPRequestExecuter.init()
        executor.makeRequest(call: requestCall) { (result) in
            if(result?.errorCode != 0)  {
              //  self.movieListVC.showAlert(title: "Error", message: result!.errorMessage)
            }
            else
            {
                if let movieListData = result?.result as? [MovieList] {
                    self.nowPlayingMovies.value = movieListData.map { MovieViewModel(meta: $0)}
                }
            }
        }

//        if movieList.count > 0 {
//            self.nowPlayingMovies.value = movieList.map { MovieViewModel(meta: $0)}
//
//        }

//
//        networkManager.getNowPlayingMovies { response, error in
//            guard let movieListData = response else { return }
//            self.nowPlayingMovies.value = movieListData.map { MovieViewModel(meta: $0)}
//            print("getNowPlayingMovies ======== getNowPlayingMovies")
//        }
    }
    
    // MARK:- functions for the viewModel
    public func getMoviesFromSearch(query: String) {
        print("query", query)
        removeSearchedMovies()
        
        //Handle clear button action
        if query.count == 0 || query.isEmpty {
            self.filteredMovies.value = self.nowPlayingMovies.value
        } else {
            self.filteredMovies.value = self.nowPlayingMovies.value?.filter({ (model) -> Bool in
                let titleArray = model.title?.split(separator: " ")
                let filteredNames = titleArray?.filter({ $0.hasPrefix(query) })
                return (filteredNames?.count ?? 0) > 0 ? true : false
            })
        }
    }
    
    mutating func getRecentSearchedMovies() {
        recentlySearchedMovies = defaultsManager.getRecentSearchMovie()
    }
    
    public func removeSearchedMovies() {
        self.filteredMovies.value = nil
    }
    
    // methods for displaying cell data
    public func getCountForDisplay(type: TableType) -> Int {
        if type == .nowPlaying {
            guard let nowPlayingViewModels =  self.nowPlayingMovies.value else { return 0 }
            return nowPlayingViewModels.count
        } else if type == .recentSearch {
            return recentlySearchedMovies.count
        } else {
            guard let recentViewModels =  self.filteredMovies.value else { return 0 }
            return recentViewModels.count
        }
    }
    
    public func prepareCellForDisplay(tableView: UITableView, indexPath: IndexPath, type: TableType) -> UITableViewCell {
        if type == .nowPlaying {
            guard let movieViewModels = self.nowPlayingMovies.value else { return UITableViewCell()}
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableCell.identifier()) as? HomeTableCell {
                cell.setupCell(viewModel: movieViewModels[indexPath.row])
                return cell
            }
        } else if type == .recentSearch {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableCell.identifier()) as? RecentSearchTableCell {
                cell.setupCell(movie: recentlySearchedMovies[indexPath.row])
                return cell
            }
        } else {
            guard let movieViewModels = self.filteredMovies.value else { return UITableViewCell()}
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableCell.identifier()) as? HomeTableCell {
                cell.setupCell(viewModel: movieViewModels[indexPath.row])
                return cell
            }
        }
        fatalError()
    }
}
