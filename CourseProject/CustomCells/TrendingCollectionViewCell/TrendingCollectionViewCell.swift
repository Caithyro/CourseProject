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
    var movieRequestDataToDisplay = MoviesResultsToSave()
    var tvRequestDataToDisplay = TvResultsToSave()
    var searchPerformed: Bool = false
    
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
        animationView!.animationSpeed = 2
        saveButton.addSubview(animationView!)
        animationView!.play(completion: removeAnimation(animationCompleted:))
        
        if DetailsViewController.shared.movieOrTvShow == 0 {
            if TrendingCollectionViewCell.shared.searchPerformed == true {
                DataManager.shared.saveMoviesToWatchLater(id: self.movieRequestDataToDisplay.id,
                                                          releaseDate: self.movieRequestDataToDisplay.releaseDate,
                                                          adult: self.movieRequestDataToDisplay.adult,
                                                          backdropPath: self.movieRequestDataToDisplay.backdropPath,
                                                          voteCount: self.movieRequestDataToDisplay.voteCount,
                                                          overview: self.movieRequestDataToDisplay.overview,
                                                          originalLanguage: self.movieRequestDataToDisplay.originalLanguage,
                                                          originalTitle: self.movieRequestDataToDisplay.originalTitle,
                                                          posterPath: self.movieRequestDataToDisplay.posterPath,
                                                          title: self.movieRequestDataToDisplay.title,
                                                          video: self.movieRequestDataToDisplay.video,
                                                          voteAverage: self.movieRequestDataToDisplay.voteAverage,
                                                          popularity: self.movieRequestDataToDisplay.popularity,
                                                          mediaType: self.movieRequestDataToDisplay.mediaType)
            } else {
                DataManager.shared.saveMoviesToWatchLater(id: self.moviesData.id,
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
            }
        } else {
            if TrendingCollectionViewCell.shared.searchPerformed == true {
                DataManager.shared.saveTvShowsToWatchLater(originalLanguage: self.tvRequestDataToDisplay.originalLanguage,
                                                           posterPath: self.tvRequestDataToDisplay.posterPath,
                                                           voteCount: self.tvRequestDataToDisplay.voteCount,
                                                           voteAverage: self.tvRequestDataToDisplay.voteAverage,
                                                           overview: self.tvRequestDataToDisplay.overview,
                                                           id: self.tvRequestDataToDisplay.id,
                                                           originalName: self.tvRequestDataToDisplay.originalName,
                                                           firstAirDate: self.tvRequestDataToDisplay.firstAirDate,
                                                           name: self.tvRequestDataToDisplay.name,
                                                           backdropPath: self.tvRequestDataToDisplay.backdropPath,
                                                           popularity: self.tvRequestDataToDisplay.popularity,
                                                           mediaType: self.tvRequestDataToDisplay.mediaType)
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
        self.posterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/w1280\(dataToDisplay.posterPath)"), placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
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
        self.posterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/w1280\(dataToDisplay.posterPath)"), placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
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
    
    func configureMoviesSearchCell(dataToDisplay: MovieSearchResults) {
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 170, height: 255), scaleMode: .fill)
        
        self.titleLabel.text = dataToDisplay.title
        self.posterImageView.layer.cornerRadius = 15
        self.posterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/original\(dataToDisplay.posterPath ?? "")"), placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.ratingLabel.text = "Average rating: \(dataToDisplay.voteAverage ?? 0.0)"
        self.releaseDateLabel.text = "Release: \(dataToDisplay.releaseDate ?? "")"
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
            originalLanguageLabel.text = dataToDisplay.originalLanguage ?? ""
        }
        self.totalVotesLabel.text = "Total votes: \(dataToDisplay.voteCount ?? 0)"
        self.mainView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.movieRequestDataToDisplay.id = dataToDisplay.id ?? 0
        self.movieRequestDataToDisplay.originalTitle = dataToDisplay.originalTitle ?? ""
        self.movieRequestDataToDisplay.title = dataToDisplay.title ?? ""
        self.movieRequestDataToDisplay.popularity = dataToDisplay.popularity ?? 0.0
        self.movieRequestDataToDisplay.voteAverage = dataToDisplay.voteAverage ?? 0.0
        self.movieRequestDataToDisplay.video = dataToDisplay.video ?? false
        self.movieRequestDataToDisplay.posterPath = dataToDisplay.posterPath ?? ""
        self.movieRequestDataToDisplay.originalLanguage = dataToDisplay.originalLanguage ?? ""
        self.movieRequestDataToDisplay.overview = dataToDisplay.overview ?? ""
        self.movieRequestDataToDisplay.voteCount = dataToDisplay.voteCount ?? 0
        self.movieRequestDataToDisplay.backdropPath = dataToDisplay.backdropPath ?? ""
        self.movieRequestDataToDisplay.adult = dataToDisplay.adult ?? false
        self.movieRequestDataToDisplay.releaseDate = dataToDisplay.releaseDate ?? ""
        self.movieRequestDataToDisplay.mediaType = "movie"
    }
    
    func configureSeriesSearchCell(dataToDisplay: TvSearchResults) {
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 170, height: 255), scaleMode: .fill)
        
        self.titleLabel.text = dataToDisplay.name
        self.posterImageView.layer.cornerRadius = 15
        self.posterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/original\(dataToDisplay.posterPath ?? "")"), placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.ratingLabel.text = "Average rating: \(dataToDisplay.voteAverage ?? 0.0)"
        self.releaseDateLabel.text = "First air: \(dataToDisplay.firstAirDate ?? "")"
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
            originalLanguageLabel.text = dataToDisplay.originalLanguage ?? ""
        }
        self.totalVotesLabel.text = "Total votes: \(dataToDisplay.voteCount ?? 0)"
        self.mainView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.tvRequestDataToDisplay.id = dataToDisplay.id ?? 0
        self.tvRequestDataToDisplay.originalName = dataToDisplay.originalName ?? ""
        self.tvRequestDataToDisplay.name = dataToDisplay.name ?? ""
        self.tvRequestDataToDisplay.popularity = dataToDisplay.popularity ?? 0.0
        self.tvRequestDataToDisplay.voteAverage = dataToDisplay.voteAverage ?? 0.0
        self.tvRequestDataToDisplay.posterPath = dataToDisplay.posterPath ?? ""
        self.tvRequestDataToDisplay.originalLanguage = dataToDisplay.originalLanguage ?? ""
        self.tvRequestDataToDisplay.overview = dataToDisplay.overview ?? ""
        self.tvRequestDataToDisplay.voteCount = dataToDisplay.voteCount ?? 0
        self.tvRequestDataToDisplay.backdropPath = dataToDisplay.backdropPath ?? ""
        self.tvRequestDataToDisplay.firstAirDate = dataToDisplay.firstAirDate ?? ""
        self.tvRequestDataToDisplay.mediaType = "tv"
    }
}
