//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//
import UIKit
import AVKit

class MovieDetailViewController: UIViewController {
    
    // MARK:- outlets for the viewController
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRuntimeLabel: UILabel!
    @IBOutlet weak var movieFansLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieCastCollectionView: UICollectionView!
    @IBOutlet weak var similarMovieCollectionView: UICollectionView!
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    
    
    
    
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    var player: AVPlayer!
    var avpController = AVPlayerViewController()

    
    @IBOutlet var videoPlayerView: UIView!
    
    // MARK:- variables for the viewController
    private let fileHandler = FileHandler()
    private let defaultsManager = UserDefaultsManager()
    public var movieViewModel: MovieViewModel!
    public var detailViewModel: DetailsViewModel!
    public var detailListViewModel: DetailListViewModel!
    
    // MARK:- lifeCycle methods for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupIU()
        self.setVideoPlayerView()
        self.setupViewModel()
    }
    
    // MARK:- utility functions for the viewController
    private func setupIU() {
        self.backButton.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        self.backButton.setCornerRadius(radius: self.backButton.frame.width / 2)
        self.movieTitleLabel.text = movieViewModel.title
        
        self.similarMovieCollectionView.delegate = self
        self.similarMovieCollectionView.dataSource = self
        self.similarMovieCollectionView.register(UINib(nibName: SimilarCollectionViewCell.identifier(), bundle: nil), forCellWithReuseIdentifier: SimilarCollectionViewCell.identifier())
        
        self.movieCastCollectionView.delegate = self
        self.movieCastCollectionView.dataSource = self
        self.movieCastCollectionView.register(UINib(nibName: CastCollectionViewCell.identifier(), bundle: nil), forCellWithReuseIdentifier: CastCollectionViewCell.identifier())
        
        self.reviewCollectionView.delegate = self
        self.reviewCollectionView.dataSource = self
        self.reviewCollectionView.register(UINib(nibName: CastCollectionViewCell.identifier(), bundle: nil), forCellWithReuseIdentifier: CastCollectionViewCell.identifier())
        self.navigationController?.navigationBar.isHidden = true

    }
    
    // MARK:  setup ViewModel
    private func setupViewModel() {
        
        self.detailViewModel = DetailsViewModel(movieId: movieViewModel.id ?? 0, moviePosterPath: movieViewModel.posterPath ?? "", fileHandler: fileHandler, defaultsManager: defaultsManager)
        self.detailListViewModel = DetailListViewModel(movieId: movieViewModel.id ?? 0, handler: fileHandler, defaultsManager: defaultsManager)
        
        guard let viewModel = self.detailViewModel else { return }
        
        // MARK: bind movieDetails list for data update
        viewModel.movieDetails.bind {
            guard let details = $0 else { return }
            DispatchQueue.main.async { [unowned self] in
                self.movieRuntimeLabel.text = "\(details.runtime ?? 0)"
                self.movieFansLabel.text = "\(Int(details.popularity ?? 0))"
                self.movieRatingLabel.text = "\(details.voteAverage ?? 0)"
                self.movieDescriptionLabel.text = details.overview
                self.releaseDateLabel.text = details.releaseDate
                self.languageLabel.text = details.originalLanguage
            }
        }
        
        
        
        // MARK: bind similarMovies list for reloadData
        self.detailListViewModel.similarMovies.bind {_ in
            self.similarMovieCollectionView.reloadData()
        }
        
        // MARK: bind movieCredits list for reloadData
        self.detailListViewModel.movieCredits.bind {_ in
            self.movieCastCollectionView.reloadData()
        }
        
        // MARK: bind movieReviews list for reloadData
        self.detailListViewModel.movieCrew.bind {_ in
            self.reviewCollectionView.reloadData()
        }
    }
    
    private func setVideoPlayerView() {
        let movieURL = Constant.baseURL + "\(movieViewModel.id ?? 0)/videos?api_key=\(Constant.APIKey)"
        
        let url = URL(string:movieURL)
        player = AVPlayer(url: url!)
        avpController.player = player
        avpController.view.frame.size.height = videoPlayerView.frame.size.height
        avpController.view.frame.size.width = videoPlayerView.frame.size.width
        self.videoPlayerView.addSubview(avpController.view)
    }
    
    
    
    
    // MARK:- objc & outlet functions for the viewController
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK:- UICollectionViewDataSource & UICollectionViewDelegateFlowLayout for the viewController

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movieCastCollectionView == collectionView {
            return self.detailListViewModel.getCountForDisplay(type: .movieCast)
        } else if reviewCollectionView == collectionView {
            return self.detailListViewModel.getCountForDisplay(type: .movieReview)
        } else {
            return self.detailListViewModel.getCountForDisplay(type: .similarMovies)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if movieCastCollectionView == collectionView {
            return self.detailListViewModel.prepareCellForDisplay(collectionView: collectionView, indexPath: indexPath, type: .movieCast)
        } else if reviewCollectionView == collectionView {
            return self.detailListViewModel.prepareCellForDisplay(collectionView: collectionView, indexPath: indexPath, type: .movieReview)
        } else {
            return self.detailListViewModel.prepareCellForDisplay(collectionView: collectionView, indexPath: indexPath, type: .similarMovies)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if reviewCollectionView == collectionView {
            return collectionView.getSizeForHorizontalCollectionView(columns: 2.3, height: CastCollectionViewCell().cellHeight)
        } else {
            return collectionView.getSizeForHorizontalCollectionView(columns: 2.3, height: SimilarCollectionViewCell().cellHeight)
        }
    }
}
