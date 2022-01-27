//
//  WatchLaterViewControllerViewModel.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 23.01.2022.
//

import Foundation
import UIKit
import Lottie

class WatchLaterViewControllerViewModel {
    
    private let dataManager = DataManager.shared
    
    var savedMoviesData: [MoviesResultsToSaveToWatchLater] = []
    var savedSeriesData: [TvResultsToSaveToWatchLater] = []
    var movieOrTvShow: Int = 0
    
    func getMoviesForWatchLater(completion: @escaping(() -> ())) {
        
        self.savedMoviesData = dataManager.getMoviesWatchLaterList()
        completion()
    }
    
    func getTvShowsForWatchLater(completion: @escaping(() -> ())) {
        
        self.savedSeriesData = dataManager.getTvWatchLaterList()
        completion()
    }
    
    func removeMovieFromWatchLater(targetMovie: Int, indexForRemove: Int) {
        
        dataManager.removeMovieFromWatchLater(targetMovie: targetMovie)
        savedMoviesData.remove(at: indexForRemove)
    }
    
    func removeTvShowFromWatchLater(targetTvShow: Int, indexForRemove: Int) {
        
        dataManager.removeTvFromWatchLater(targetTvShow: targetTvShow)
        savedSeriesData.remove(at: indexForRemove)
    }
    
    func runDeleteAnimation(animationView: AnimationView?, mainView: UIView, imageView: UIImageView,
                   titleLabel: UILabel, ratingLabel: UILabel, totalVotesLabel: UILabel,
                   releaseDateLabel: UILabel, originalLanguageLabel: UILabel) {
        
        if animationView != nil {
            animationView!.frame = mainView.bounds
            animationView!.contentMode = .scaleAspectFit
            animationView!.loopMode = .playOnce
            animationView!.animationSpeed = 2
            mainView.addSubview(animationView!)
            mainView.bringSubviewToFront(animationView!)
            imageView.image = .none
            titleLabel.text = ""
            ratingLabel.text = ""
            totalVotesLabel.text = ""
            releaseDateLabel.text = ""
            originalLanguageLabel.text = ""
        }
    }
}
