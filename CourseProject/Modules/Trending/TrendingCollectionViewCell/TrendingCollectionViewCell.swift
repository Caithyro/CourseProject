//
//  TrendingCollectionViewCell.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit
import SDWebImage
import Lottie

class TrendingCollectionViewCell: UICollectionViewCell {
    
    var trendingViewModel = TrendingViewControllerViewModel()
    var moviesData = MoviesResultsToSave()
    var seriesData = TvResultsToSave()
    var mediaType = 0
    
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
        
        saveAnimationView = .init(name: "heartAnimation")
        trendingViewModel.setupSaveAnimation(animationView: saveAnimationView, button: saveButton)
        saveAnimationView?.play(completion: removeSaveAnimationView(animationCompleted:))
        
        if self.mediaType == 0 {
            do {
                trendingViewModel.saveMovieToWatchLater(dataToSave: self.moviesData)
                trendingViewModel.displaySaveStatusAlert(saveSuccess: true)
            } catch {
                trendingViewModel.displaySaveStatusAlert(saveSuccess: false)
            }
        } else {
            do {
                trendingViewModel.savaTvShowToWatchLater(dataToSave: self.seriesData)
                trendingViewModel.displaySaveStatusAlert(saveSuccess: true)
            } catch {
                trendingViewModel.displaySaveStatusAlert(saveSuccess: false)
            }
        }
    }
    
    
    func configureMoviesCell(dataToDisplay: MoviesResults) {
        
        let posterUrlString = "\(imageUrlString)\(dataToDisplay.posterPath ?? "")"
        self.titleLabel.text = dataToDisplay.title
        self.posterImageView.layer.cornerRadius = 15
        self.posterImageView.sd_setImage(with: URL(string: posterUrlString),
                                         placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.ratingLabel.text = "\(averageRatingString) \(dataToDisplay.voteAverage ?? 0.0)"
        self.releaseDateLabel.text = "\(releaseDateString) \(dataToDisplay.releaseDate ?? "")"
        self.originalLanguageLabel.text =
        "\(originalLanguageString) \(originalLanguages[dataToDisplay.originalLanguage ?? ""] ?? "nil")"
        self.totalVotesLabel.text = "\(totalVotesString) \(dataToDisplay.voteCount ?? 0)"
        self.mainView.layer.backgroundColor = transparentBackgroundColor
        self.mediaType = 0
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
        
        let posterUrlString = "\(imageUrlString)\(dataToDisplay.posterPath ?? "")"
        self.titleLabel.text = dataToDisplay.name
        self.posterImageView.layer.cornerRadius = 15
        self.posterImageView.sd_setImage(with: URL(string: posterUrlString),
                                         placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.ratingLabel.text = "\(averageRatingString) \(dataToDisplay.voteAverage ?? 0.0)"
        self.releaseDateLabel.text = "\(firstAirString) \(dataToDisplay.firstAirDate ?? "")"
        self.originalLanguageLabel.text =
        "\(originalLanguageString) \(originalLanguages[dataToDisplay.originalLanguage ?? ""] ?? "nil")"
        self.totalVotesLabel.text = "\(totalVotesString) \(dataToDisplay.voteCount ?? 0)"
        self.mainView.layer.backgroundColor = transparentBackgroundColor
        self.mediaType = 1
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
}
