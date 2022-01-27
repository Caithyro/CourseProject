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
    
    var watchLaterViewModel = WatchLaterViewControllerViewModel()
    var delegate: WatchLaterDeleteDelegate?
    var movieOrTvShow: Int = 0
    var indexForRemove: Int = 0
    
    @IBOutlet weak var watchLaterMainView: UIView!
    @IBOutlet weak var watchLaterImageView: UIImageView!
    @IBOutlet weak var watchLaterTitleLabel: UILabel!
    @IBOutlet weak var watchLaterRatingLabel: UILabel!
    @IBOutlet weak var watchLaterTotalVotesLabel: UILabel!
    @IBOutlet weak var watchLaterReleaseDateLabel: UILabel!
    @IBOutlet weak var watchLaterOriginalLanguageLabel: UILabel!
    
    private var moviesData = MoviesResultsToSaveToWatchLater()
    private var seriesData = TvResultsToSaveToWatchLater()
    private var deleteAnimationView: AnimationView?
    private let transformer = SDImageResizingTransformer(size: CGSize(width: 170, height: 255), scaleMode: .fill)
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.watchLaterMainView.layer.backgroundColor = transparentBackgroundColor
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        deleteAnimationView = .init(name: "deleteAnimation")
        watchLaterViewModel.runDeleteAnimation(animationView: deleteAnimationView,
                                               mainView: watchLaterMainView,
                                               imageView: watchLaterImageView,
                                               titleLabel: watchLaterTitleLabel,
                                               ratingLabel: watchLaterRatingLabel,
                                               totalVotesLabel: watchLaterTotalVotesLabel,
                                               releaseDateLabel: watchLaterReleaseDateLabel,
                                               originalLanguageLabel: watchLaterOriginalLanguageLabel)
        deleteAnimationView?.play(completion: removeFromWatchLater(animationCompleted:))
    }
    
    func configureMoviesCell(dataToDisplay: MoviesResultsToSaveToWatchLater) {
        
        let posterImageUrlString = "\(imageUrlString)\(dataToDisplay.posterPath)"
        self.watchLaterImageView.layer.cornerRadius = 15
        self.watchLaterImageView.sd_setImage(with: URL(string: posterImageUrlString),
                                             placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.watchLaterTitleLabel.text = "\(dataToDisplay.title)"
        self.watchLaterRatingLabel.text = "\(averageRatingString) \(dataToDisplay.voteAverage)"
        self.watchLaterTotalVotesLabel.text = "\(totalVotesString) \(dataToDisplay.voteCount)"
        self.watchLaterReleaseDateLabel.text = "\(releaseDateString) \(dataToDisplay.releaseDate)"
        self.watchLaterOriginalLanguageLabel.text = "\(originalLanguageString) \(originalLanguages[dataToDisplay.originalLanguage] ?? "nil")"
        self.moviesData = dataToDisplay
    }
    
    func configureSeriesCell(dataToDisplay: TvResultsToSaveToWatchLater) {
        
        let posterImageUrlString = "\(imageUrlString)\(dataToDisplay.posterPath)"
        self.watchLaterImageView.layer.cornerRadius = 15
        self.watchLaterImageView.sd_setImage(with: URL(string: posterImageUrlString),
                                             placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.watchLaterTitleLabel.text = "\(dataToDisplay.name)"
        self.watchLaterRatingLabel.text = "\(averageRatingString) \(dataToDisplay.voteAverage)"
        self.watchLaterTotalVotesLabel.text = "\(totalVotesString) \(dataToDisplay.voteCount)"
        self.watchLaterReleaseDateLabel.text = "\(firstAirString) \(dataToDisplay.firstAirDate)"
        self.watchLaterOriginalLanguageLabel.text = "\(originalLanguageString) \(originalLanguages[dataToDisplay.originalLanguage] ?? "nil")"
        self.seriesData = dataToDisplay
    }
    
    // MARK: - Private
    
    private func removeFromWatchLater(animationCompleted: Bool) {
        
        if movieOrTvShow == 0 {
            delegate?.removeMovie(targetMovie: moviesData.id, indexForRemove: indexForRemove)
        } else {
            delegate?.removeTvShow(targetTvShow: seriesData.id, indexForRemove: indexForRemove)
        }
        deleteAnimationView?.removeFromSuperview()
    }
}
