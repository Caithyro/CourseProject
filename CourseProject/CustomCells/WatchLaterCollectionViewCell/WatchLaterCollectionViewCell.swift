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
    let languagesDictionary = DetailsConstants().originalLanguages
    
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
        self.watchLaterMainView.layer.backgroundColor = .init(genericCMYKCyan: 0.0, magenta: 0.0, yellow: 0, black: 0.0, alpha: 0)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        runDeleteAnimation()
    }
    
    func configureMoviesCell(dataToDisplay: MoviesResultsToSaveToWatchLater) {

        self.watchLaterImageView.layer.cornerRadius = 15
        self.watchLaterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/w1280\(dataToDisplay.posterPath)"),
                                             placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.watchLaterTitleLabel.text = "\(dataToDisplay.title)"
        self.watchLaterRatingLabel.text = "Average rating: \(dataToDisplay.voteAverage)"
        self.watchLaterTotalVotesLabel.text = "Total votes: \(dataToDisplay.voteCount)"
        self.watchLaterReleaseDateLabel.text = "Release: \(dataToDisplay.releaseDate)"
        self.watchLaterOriginalLanguageLabel.text = "Original language: \(languagesDictionary[dataToDisplay.originalLanguage] ?? "nil")"
        self.moviesData = dataToDisplay
    }
    
    func configureSeriesCell(dataToDisplay: TvResultsToSaveToWatchLater) {
        
        self.watchLaterImageView.layer.cornerRadius = 15
        self.watchLaterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/w1280\(dataToDisplay.posterPath)"),
                                             placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.watchLaterTitleLabel.text = "\(dataToDisplay.name)"
        self.watchLaterRatingLabel.text = "Average rating: \(dataToDisplay.voteAverage)"
        self.watchLaterTotalVotesLabel.text = "Total votes: \(dataToDisplay.voteCount)"
        self.watchLaterReleaseDateLabel.text = "First air: \(dataToDisplay.firstAirDate)"
        self.watchLaterOriginalLanguageLabel.text = "Original language: \(languagesDictionary[dataToDisplay.originalLanguage] ?? "nil")"
        self.seriesData = dataToDisplay
    }
    
    // MARK: - Private
    
    private func runDeleteAnimation() {
        
        deleteAnimationView = .init(name: "deleteAnimation")
        if deleteAnimationView != nil {
            deleteAnimationView!.frame = self.bounds
            deleteAnimationView!.contentMode = .scaleAspectFit
            deleteAnimationView!.loopMode = .playOnce
            deleteAnimationView!.animationSpeed = 2
            watchLaterMainView.addSubview(deleteAnimationView!)
            watchLaterMainView.bringSubviewToFront(deleteAnimationView!)
            watchLaterImageView.image = .none
            watchLaterTitleLabel.text = ""
            watchLaterRatingLabel.text = ""
            watchLaterTotalVotesLabel.text = ""
            watchLaterReleaseDateLabel.text = ""
            watchLaterOriginalLanguageLabel.text = ""
            deleteAnimationView!.play(completion: removeDeleteAnimation(animationCompleted:))
        }
    }
    
    private func removeDeleteAnimation(animationCompleted: Bool) {
        
        if animationCompleted == true {
            deleteAnimationView!.removeFromSuperview()
            if DetailsViewController.shared.movieOrTvShow == 0 {
                DataManager.shared.removeMovieFromWatchLater(targetMovie: moviesData.id)
            } else {
                DataManager.shared.removeTvFromWatchLater(targetTvShow: seriesData.id)
            }
        }
    }
}
