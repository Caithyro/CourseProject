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
    let languagesDictionary = DetailsConstants().originalLanguages
    weak var trendingViewControllerInstance = TrendingViewController()
    
    var moviesData = MoviesResultsToSave()
    var seriesData = TvResultsToSave()
    var searchPerformed: Bool = false
    var movieOrTvShow: Int = 0
    
    private var movieRequestDataToDisplay = MoviesResultsToSave()
    private var tvRequestDataToDisplay = TvResultsToSave()
    private var saveAnimationView: AnimationView?
    private let transformer = SDImageResizingTransformer(size: CGSize(width: 170, height: 255), scaleMode: .fill)
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var totalVotesLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func saveToWatchLaterButtonPressed(_ sender: Any) {
        
        runSaveAnimation()
        if TrendingCollectionViewCell.shared.movieOrTvShow == 0 {
            if TrendingCollectionViewCell.shared.searchPerformed == true {
                saveMovieFromRequestToWatchLater()
            } else {
                saveMovieFromTrendingToWatchLater()
            }
        } else {
            if TrendingCollectionViewCell.shared.searchPerformed == true {
                saveTvShowFromRequestToWatchLater()
            } else {
                saveTvShowFromTrendingToWatchLater()
            }
        }
    }
    
    
    func configureMoviesCell(dataToDisplay: MoviesResultsToSave) {
        
        self.titleLabel.text = dataToDisplay.title
        self.posterImageView.layer.cornerRadius = 15
        self.posterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/w1280\(dataToDisplay.posterPath)"),
                                         placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.ratingLabel.text = "Average rating: \(dataToDisplay.voteAverage)"
        self.releaseDateLabel.text = "Release: \(dataToDisplay.releaseDate)"
        self.originalLanguageLabel.text = "Original language: \(languagesDictionary[dataToDisplay.originalLanguage] ?? "nil")"
        self.totalVotesLabel.text = "Total votes: \(dataToDisplay.voteCount)"
        self.mainView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.moviesData = dataToDisplay
        
    }
    
    func configureSeriesCell(dataToDisplay: TvResultsToSave) {
        
        self.titleLabel.text = dataToDisplay.name
        self.posterImageView.layer.cornerRadius = 15
        self.posterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/w1280\(dataToDisplay.posterPath)"),
                                         placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.ratingLabel.text = "Average rating: \(dataToDisplay.voteAverage)"
        self.releaseDateLabel.text = "First air: \(dataToDisplay.firstAirDate)"
        self.originalLanguageLabel.text = "Original language: \(languagesDictionary[dataToDisplay.originalLanguage] ?? "nil")"
        self.totalVotesLabel.text = "Total votes: \(dataToDisplay.voteCount)"
        self.mainView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.seriesData = dataToDisplay
    }
    
    func configureMoviesSearchCell(dataToDisplay: MovieSearchResults) {
        
        self.titleLabel.text = dataToDisplay.title
        self.posterImageView.layer.cornerRadius = 15
        self.posterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/original\(dataToDisplay.posterPath ?? "")"),
                                         placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.ratingLabel.text = "Average rating: \(dataToDisplay.voteAverage ?? 0.0)"
        self.releaseDateLabel.text = "Release: \(dataToDisplay.releaseDate ?? "")"
        self.originalLanguageLabel.text = "Original language: \(languagesDictionary[dataToDisplay.originalLanguage ?? "nil"] ?? "nil")"
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
        
        self.titleLabel.text = dataToDisplay.name
        self.posterImageView.layer.cornerRadius = 15
        self.posterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/original\(dataToDisplay.posterPath ?? "")"),
                                         placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.ratingLabel.text = "Average rating: \(dataToDisplay.voteAverage ?? 0.0)"
        self.releaseDateLabel.text = "First air: \(dataToDisplay.firstAirDate ?? "")"
        self.originalLanguageLabel.text = "Original language: \(languagesDictionary[dataToDisplay.originalLanguage ?? "nil"] ?? "nil")"
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
    
    // MARK: - Private
    
    private func removeSaveAnimationView(animationCompleted: Bool) {
        
        if animationCompleted == true {
            saveAnimationView?.removeFromSuperview()
        }
    }
    
    private func runSaveAnimation() {
        
        saveAnimationView = .init(name: "heartAnimation")
        if saveAnimationView != nil {
            saveAnimationView!.frame = saveButton.bounds
            saveAnimationView!.contentMode = .scaleAspectFit
            saveAnimationView!.loopMode = .playOnce
            saveAnimationView!.animationSpeed = 2
            saveButton.addSubview(saveAnimationView!)
            saveAnimationView!.play(completion: removeSaveAnimationView(animationCompleted:))
        }
    }
    
    private func saveMovieFromRequestToWatchLater() {
        
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
    }
    
    private func saveMovieFromTrendingToWatchLater() {
        
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
    
    private func saveTvShowFromRequestToWatchLater() {
        
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
    }
    
    private func saveTvShowFromTrendingToWatchLater() {
        
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
