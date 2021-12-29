//
//  TrendingCollectionViewCell.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit
import SDWebImage
import Lottie
import SwiftUI

class TrendingCollectionViewCell: UICollectionViewCell {
    
    static let shared = TrendingCollectionViewCell()
    weak var trendingViewControllerInstance = TrendingViewController()
    
    var moviesData = MoviesResultsToSave()
    var seriesData = TvResultsToSave()
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var totalVotesLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    private var animationView: AnimationView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func saveToWatchLaterButtonPressed(_ sender: Any) {
        
        animationView = .init(name: "heartAnimation")
        animationView!.frame = saveButton.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 1
        saveButton.addSubview(animationView!)
        animationView!.play(completion: removeAnimation(animationCompleted:))
        
        if DetailsViewController.shared.movieOrTvShow == 0 {
            DataManager.shared.saveMoviesToWatchLater(id: moviesData.id,
                                                      releaseDate: self.moviesData.releaseDate,
                                                      adult: self.moviesData.adult,
                                                      backdropPath: self.moviesData.backdropPath,
                                                      voteCount: self.moviesData.voteCount,
                                                      overview: self.moviesData.overview,
                                                      originalLanguage: self.moviesData.originalLanguage,
                                                      originalTitle: self.moviesData.originalTitle,
                                                      posterPath: self.moviesData.posterPath,
                                                      title: self.moviesData.title,
                                                      video: self.moviesData.video,
                                                      voteAverage: self.moviesData.voteAverage,
                                                      popularity: self.moviesData.popularity,
                                                      mediaType: self.moviesData.mediaType)
        } else {
            DataManager.shared.saveTvShowsToWatchLater(originalLanguage: self.seriesData.originalLanguage,
                                                       posterPath: self.seriesData.posterPath,
                                                       voteCount: self.seriesData.voteCount,
                                                       voteAverage: self.seriesData.voteAverage,
                                                       overview: self.seriesData.overview,
                                                       id: self.seriesData.id,
                                                       originalName: self.seriesData.originalName,
                                                       firstAirDate: self.seriesData.firstAirDate,
                                                       name: self.seriesData.name,
                                                       backdropPath: self.seriesData.backdropPath,
                                                       popularity: self.seriesData.popularity,
                                                       mediaType: self.seriesData.mediaType)
        }
    }
    
    func removeAnimation(animationCompleted: Bool) {
        if animationCompleted == true {
            animationView!.removeFromSuperview()
        }
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
        } else if dataToDisplay.originalLanguage == "ko" {
            originalLanguageLabel.text = "Original language: Korean"
        } else if dataToDisplay.originalLanguage == "it" {
            originalLanguageLabel.text = "Original language: Italian"
        } else if dataToDisplay.originalLanguage == "ja" {
            originalLanguageLabel.text = "Original language: Japanese"
        } else if dataToDisplay.originalLanguage == "fr" {
            originalLanguageLabel.text = "Original language: French"
        } else if dataToDisplay.originalLanguage == "ml" {
            originalLanguageLabel.text = "Original language: Malayalam"
        } else {
            originalLanguageLabel.text = dataToDisplay.originalLanguage
        }
        self.totalVotesLabel.text = "Total votes: \(dataToDisplay.voteCount)"
        self.mainView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.moviesData = dataToDisplay
        
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
        } else if dataToDisplay.originalLanguage == "ko" {
            originalLanguageLabel.text = "Original language: Korean"
        } else if dataToDisplay.originalLanguage == "it" {
            originalLanguageLabel.text = "Original language: Italian"
        } else if dataToDisplay.originalLanguage == "ja" {
            originalLanguageLabel.text = "Original language: Japanese"
        } else if dataToDisplay.originalLanguage == "fr" {
            originalLanguageLabel.text = "Original language: French"
        } else if dataToDisplay.originalLanguage == "ml" {
            originalLanguageLabel.text = "Original language: Malayalam"
        } else {
            originalLanguageLabel.text = dataToDisplay.originalLanguage
        }
        self.totalVotesLabel.text = "Total votes: \(dataToDisplay.voteCount)"
        self.mainView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.seriesData = dataToDisplay
    }
}

