//
//  MovieListVC.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//

import UIKit

class MovieListVC: UIViewController {

    @IBOutlet var movieTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    lazy var movieListVM: MovieListVM = {
        return MovieListVM(movieListVC: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
}

extension MovieListVC {
    
    func setupUI() {
        setupAlertTableView()
    }
    
    func setupAlertTableView() {
        movieTableView.estimatedRowHeight = 44
        movieTableView.backgroundColor = .clear
        movieTableView.separatorStyle = .none
        movieTableView.bounces = false
        movieTableView.rowHeight = UITableView.automaticDimension
        movieTableView.showsVerticalScrollIndicator = false
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        movieTableView.register(UINib(nibName: "MovieListCell", bundle: nil), forCellReuseIdentifier: "MovieListCell")
    }
}
extension MovieListVC {
    func reloadData() {
        movieTableView.reloadData()
    }
}

extension MovieListVC: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return movieListVM.getNumberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListVM.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hView = UIView()
        hView.backgroundColor = UIColor.clear
        return hView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieListCell",
            for: indexPath
            ) as! MovieListCell
        cell.setBorder(color: UIColor.gray, width: 0.5)
      
        cell.configureView(resultsObj: movieListVM.getMovieDetail(index: indexPath.section)!)
                            
        cell.selectionStyle = .none
        return cell
        
    }
}

extension MovieListVC {
// MARK:- Activity Indicator
     func startLoading() {
         self.activityIndicator.startAnimating()
         self.view.isUserInteractionEnabled = false
         self.activityIndicator.isHidden = false
     }
     
     func stopLoading() {
         self.activityIndicator.stopAnimating()
         self.view.isUserInteractionEnabled = true
         self.activityIndicator.isHidden = true
     }
}
