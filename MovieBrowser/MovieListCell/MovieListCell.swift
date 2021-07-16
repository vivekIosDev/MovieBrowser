//
//  MovieListCell.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//

import UIKit

class MovieListCell: UITableViewCell {
    
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieName: UILabel!
    @IBOutlet var movieReleaseDate: UILabel!
    @IBOutlet var movieOtherDetail: UILabel!
    @IBOutlet var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playButton.setCornerRadius(radius: 8)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureView(resultsObj:Results) {
        
        if let title = resultsObj.title {
            movieName.text = title
        }
        
        if let releaseDate = resultsObj.release_date {
            movieReleaseDate.text = releaseDate
        }
        
        if let otherDetail = resultsObj.overview {
            movieOtherDetail.text = otherDetail
        }
  
        }
    
}
