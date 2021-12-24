//
//  TrendingCollectionViewCell.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit
import SDWebImage

class TrendingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var totalVotesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureMoviesCell(dataToDisplay: MoviesResultsToSave) {
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 170, height: 255), scaleMode: .fill)
        
        self.titleLabel.text = dataToDisplay.title
        self.posterImageView.layer.cornerRadius = 15
        self.posterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/w1280\(dataToDisplay.posterPath)"), placeholderImage: nil, context: [.imageTransformer: transformer])
        self.ratingLabel.text = "Average rating: \(dataToDisplay.voteAverage)"
        self.releaseDateLabel.text = "Release: \(dataToDisplay.releaseDate)"
        if dataToDisplay.originalLanguage == "en" {
            originalLanguageLabel.text = "Original language: English"
        } else if dataToDisplay.originalLanguage == "es" {
            originalLanguageLabel.text = "Original language: Spanish"
        } else if dataToDisplay.originalLanguage == "ru" {
            originalLanguageLabel.text = "Original language: Russian"
        } else {
            originalLanguageLabel.text = dataToDisplay.originalLanguage
        }
        self.totalVotesLabel.text = "Total votes: \(dataToDisplay.voteCount)"
        self.mainView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
    }
    
    func configureSeriesCell(dataToDisplay: TvResultsToSave) {
        let transformer = SDImageResizingTransformer(size: CGSize(width: 170, height: 255), scaleMode: .fill)
        
        self.titleLabel.text = dataToDisplay.name
        self.posterImageView.layer.cornerRadius = 15
        self.posterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/w1280\(dataToDisplay.posterPath)"), placeholderImage: nil, context: [.imageTransformer: transformer])
        self.ratingLabel.text = "Average rating: \(dataToDisplay.voteAverage)"
        self.releaseDateLabel.text = "First air: \(dataToDisplay.firstAirDate)"
        if dataToDisplay.originalLanguage == "en" {
            originalLanguageLabel.text = "Original language: English"
        } else if dataToDisplay.originalLanguage == "es" {
            originalLanguageLabel.text = "Original language: Spanish"
        } else if dataToDisplay.originalLanguage == "ru" {
            originalLanguageLabel.text = "Original language: Russian"
        } else {
            originalLanguageLabel.text = dataToDisplay.originalLanguage
        }
        self.totalVotesLabel.text = "Total votes: \(dataToDisplay.voteCount)"
        self.mainView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
    }
}

