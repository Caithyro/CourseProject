//
//  WatchLaterCollectionViewCell.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit
import SDWebImage
import Lottie

class WatchLaterCollectionViewCell: UICollectionViewCell {
    
    static let shared = WatchLaterCollectionViewCell()
    
    @IBOutlet weak var watchLaterMainView: UIView!
    @IBOutlet weak var watchLaterImageView: UIImageView!
    @IBOutlet weak var watchLaterTitleLabel: UILabel!
    @IBOutlet weak var watchLaterRatingLabel: UILabel!
    @IBOutlet weak var watchLaterTotalVotesLabel: UILabel!
    @IBOutlet weak var watchLaterReleaseDateLabel: UILabel!
    @IBOutlet weak var watchLaterOriginalLanguageLabel: UILabel!
    private var animationView: AnimationView?
    
    var moviesData = MoviesResultsToSaveToWatchLater()
    var seriesData = TvResultsToSaveToWatchLater()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.watchLaterMainView.layer.backgroundColor = .init(genericCMYKCyan: 0.0, magenta: 0.0, yellow: 0, black: 0.0, alpha: 0)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        runDeleteAnimation()
    }
        
    
    func runDeleteAnimation() {
        animationView = .init(name: "deleteAnimation")
        animationView!.frame = self.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 2
        watchLaterMainView.addSubview(animationView!)
        watchLaterMainView.bringSubviewToFront(animationView!)
        watchLaterImageView.image = .none
        watchLaterTitleLabel.text = ""
        watchLaterRatingLabel.text = ""
        watchLaterTotalVotesLabel.text = ""
        watchLaterReleaseDateLabel.text = ""
        watchLaterOriginalLanguageLabel.text = ""
        animationView!.play(completion: removeAnimation(animationCompleted:))
    }
    
    func removeAnimation(animationCompleted: Bool) {
        if animationCompleted == true {
            animationView!.removeFromSuperview()
            if DetailsViewController.shared.movieOrTvShow == 0 {
                DataManager.shared.removeMovieFromWatchLater(targetMovie: moviesData.id)
            } else {
                DataManager.shared.removeTvFromWatchLater(targetTvShow: seriesData.id)
            }
        }
    }
    
    func configureMoviesCell(dataToDisplay: MoviesResultsToSaveToWatchLater) {
        let transformer = SDImageResizingTransformer(size: CGSize(width: 170, height: 255), scaleMode: .fill)
        
        self.watchLaterImageView.layer.cornerRadius = 15
        self.watchLaterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/w1280\(dataToDisplay.posterPath)"), placeholderImage: nil, context: [.imageTransformer: transformer])
        self.watchLaterTitleLabel.text = "\(dataToDisplay.title)"
        self.watchLaterRatingLabel.text = "Average rating: \(dataToDisplay.voteAverage)"
        self.watchLaterTotalVotesLabel.text = "Total votes: \(dataToDisplay.voteCount)"
        self.watchLaterReleaseDateLabel.text = "Release: \(dataToDisplay.releaseDate)"
        if dataToDisplay.originalLanguage == "en" {
            watchLaterOriginalLanguageLabel.text = "Original language: English"
        } else if dataToDisplay.originalLanguage == "es" {
            watchLaterOriginalLanguageLabel.text = "Original language: Spanish"
        } else if dataToDisplay.originalLanguage == "ru" {
            watchLaterOriginalLanguageLabel.text = "Original language: Russian"
        } else if dataToDisplay.originalLanguage == "ko" {
            watchLaterOriginalLanguageLabel.text = "Original language: Korean"
        } else if dataToDisplay.originalLanguage == "it" {
            watchLaterOriginalLanguageLabel.text = "Original language: Italian"
        } else if dataToDisplay.originalLanguage == "ja" {
            watchLaterOriginalLanguageLabel.text = "Original language: Japanese"
        } else if dataToDisplay.originalLanguage == "fr" {
            watchLaterOriginalLanguageLabel.text = "Original language: French"
        } else if dataToDisplay.originalLanguage == "ml" {
            watchLaterOriginalLanguageLabel.text = "Original language: Malayalam"
        } else {
            watchLaterOriginalLanguageLabel.text = dataToDisplay.originalLanguage
        }
        self.moviesData = dataToDisplay
    }
    
    func configureSeriesCell(dataToDisplay: TvResultsToSaveToWatchLater) {
        let transformer = SDImageResizingTransformer(size: CGSize(width: 170, height: 255), scaleMode: .fill)
        
        self.watchLaterImageView.layer.cornerRadius = 15
        self.watchLaterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/w1280\(dataToDisplay.posterPath)"), placeholderImage: nil, context: [.imageTransformer: transformer])
        self.watchLaterTitleLabel.text = "\(dataToDisplay.name)"
        self.watchLaterRatingLabel.text = "Average rating: \(dataToDisplay.voteAverage)"
        self.watchLaterTotalVotesLabel.text = "Total votes: \(dataToDisplay.voteCount)"
        self.watchLaterReleaseDateLabel.text = "First air: \(dataToDisplay.firstAirDate)"
        if dataToDisplay.originalLanguage == "en" {
            watchLaterOriginalLanguageLabel.text = "Original language: English"
        } else if dataToDisplay.originalLanguage == "es" {
            watchLaterOriginalLanguageLabel.text = "Original language: Spanish"
        } else if dataToDisplay.originalLanguage == "ru" {
            watchLaterOriginalLanguageLabel.text = "Original language: Russian"
        } else if dataToDisplay.originalLanguage == "ko" {
            watchLaterOriginalLanguageLabel.text = "Original language: Korean"
        } else if dataToDisplay.originalLanguage == "it" {
            watchLaterOriginalLanguageLabel.text = "Original language: Italian"
        } else if dataToDisplay.originalLanguage == "ja" {
            watchLaterOriginalLanguageLabel.text = "Original language: Japanese"
        } else if dataToDisplay.originalLanguage == "fr" {
            watchLaterOriginalLanguageLabel.text = "Original language: French"
        } else if dataToDisplay.originalLanguage == "ml" {
            watchLaterOriginalLanguageLabel.text = "Original language: Malayalam"
        } else {
            watchLaterOriginalLanguageLabel.text = dataToDisplay.originalLanguage
        }
        self.seriesData = dataToDisplay
    }
}
