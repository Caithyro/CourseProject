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
    let languagesDictionary = DetailsViewController.shared.detailsViewModel.originalLanguages
    weak var trendingViewControllerInstance = TrendingViewController()
    
    var moviesData = MoviesResultsToSave()
    var seriesData = TvResultsToSave()
    var searchPerformed: Bool = false
    var movieOrTvShow: Int = 0
    
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
            saveMovieToWatchLater()
        } else {
            saveTvShowToWatchLater()
        }
    }
    
    
    func configureMoviesCell(dataToDisplay: MoviesResults) {
        
        self.titleLabel.text = dataToDisplay.title
        self.posterImageView.layer.cornerRadius = 15
        self.posterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/w1280\(dataToDisplay.posterPath ?? "")"),
                                         placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.ratingLabel.text = "\(TrendingConstants.averageRatingString) \(dataToDisplay.voteAverage ?? 0.0)"
        self.releaseDateLabel.text = "\(TrendingConstants.releaseDateString) \(dataToDisplay.releaseDate ?? "")"
        self.originalLanguageLabel.text =
        "\(TrendingConstants.originalLanguageString) \(languagesDictionary[dataToDisplay.originalLanguage ?? ""] ?? "nil")"
        self.totalVotesLabel.text = "\(TrendingConstants.totalVotesString) \(dataToDisplay.voteCount ?? 0)"
        self.mainView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.moviesData.id = dataToDisplay.id ?? 0
        self.moviesData.releaseDate = dataToDisplay.releaseDate ?? ""
        self.moviesData.adult = dataToDisplay.adult ?? false
        self.moviesData.backdropPath = dataToDisplay.backdropPath ?? ""
        self.moviesData.voteCount = dataToDisplay.voteCount ?? 0
        self.moviesData.overview = dataToDisplay.overview ?? ""
        self.moviesData.originalLanguage = dataToDisplay.originalLanguage ?? ""
        self.moviesData.originalTitle = dataToDisplay.originalTitle ?? ""
        self.moviesData.posterPath = dataToDisplay.posterPath ?? ""
        self.moviesData.title = dataToDisplay.title ?? ""
        self.moviesData.video = dataToDisplay.video ?? false
        self.moviesData.voteAverage = dataToDisplay.voteAverage ?? 0.0
        self.moviesData.popularity = dataToDisplay.popularity ?? 0.0
        self.moviesData.mediaType = dataToDisplay.mediaType ?? ""
    }
    
    func configureSeriesCell(dataToDisplay: TvResults) {
        
        self.titleLabel.text = dataToDisplay.name
        self.posterImageView.layer.cornerRadius = 15
        self.posterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/w1280\(dataToDisplay.posterPath ?? "")"),
                                         placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.ratingLabel.text = "\(TrendingConstants.averageRatingString) \(dataToDisplay.voteAverage ?? 0.0)"
        self.releaseDateLabel.text = "\(TrendingConstants.firstAirString) \(dataToDisplay.firstAirDate ?? "")"
        self.originalLanguageLabel.text =
        "\(TrendingConstants.originalLanguageString) \(languagesDictionary[dataToDisplay.originalLanguage ?? ""] ?? "nil")"
        self.totalVotesLabel.text = "\(TrendingConstants.totalVotesString) \(dataToDisplay.voteCount ?? 0)"
        self.mainView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.seriesData.id = dataToDisplay.id ?? 0
        self.seriesData.firstAirDate = dataToDisplay.firstAirDate ?? ""
        self.seriesData.backdropPath = dataToDisplay.backdropPath ?? ""
        self.seriesData.voteCount = dataToDisplay.voteCount ?? 0
        self.seriesData.overview = dataToDisplay.overview ?? ""
        self.seriesData.originalLanguage = dataToDisplay.originalLanguage ?? ""
        self.seriesData.originalName = dataToDisplay.originalName ?? ""
        self.seriesData.posterPath = dataToDisplay.posterPath ?? ""
        self.seriesData.name = dataToDisplay.name ?? ""
        self.seriesData.voteAverage = dataToDisplay.voteAverage ?? 0.0
        self.seriesData.popularity = dataToDisplay.popularity ?? 0.0
        self.seriesData.mediaType = dataToDisplay.mediaType ?? ""
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
    
    private func saveMovieToWatchLater() {
        
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
    
    private func saveTvShowToWatchLater() {
        
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
