//
//  TrendingViewControllerViewModel.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 23.01.2022.
//

import Foundation
import StatusAlert
import Lottie
import UIKit

class TrendingViewControllerViewModel {
    
    let requestManager = RequestManager.shared
    let dataManager = DataManager.shared
    
    var movieOrTvShow: Int = 0
    var searchPerformed: Bool = false
    var moviesResponceData: [MoviesResults] = []
    var tvShowsResponceData: [TvResults] = []
    
    func loadMovies(searchPerformed: Bool, query: String, completion: @escaping(() -> ())) {
        
        if searchPerformed == false {
            requestManager.requestMovies(completion: { movies in
                self.moviesResponceData = movies
                completion()
            })
        } else {
            requestManager.movieSearchRequest(query: query,
                                              completion: { movies in
                self.moviesResponceData = movies
                completion()
            })
        }
    }
    
    func loadTvShows(searchPerformed: Bool, query: String, completion: @escaping(() -> ())) {
        
        if searchPerformed == false {
            requestManager.requestTvShows(completion: { tvShows in
                self.tvShowsResponceData = tvShows
                completion()
            })
        } else {
            requestManager.tvSearchRequest(query: query,
                                           completion: { tvShows in
                self.tvShowsResponceData = tvShows
                completion()
            })
        }
    }
    
    func saveMovieToWatchLater(dataToSave: MoviesResultsToSave) {
        
        dataManager.saveMoviesToWatchLater(id: dataToSave.id,
                                           releaseDate: dataToSave.releaseDate,
                                           adult: dataToSave.adult,
                                           backdropPath: dataToSave.backdropPath,
                                           voteCount: dataToSave.voteCount,
                                           overview: dataToSave.overview,
                                           originalLanguage: dataToSave.originalLanguage,
                                           originalTitle: dataToSave.originalTitle,
                                           posterPath: dataToSave.posterPath,
                                           title: dataToSave.title,
                                           video: dataToSave.video,
                                           voteAverage: dataToSave.voteAverage,
                                           popularity: dataToSave.popularity,
                                           mediaType: dataToSave.mediaType)
    }
    
    func savaTvShowToWatchLater(dataToSave: TvResultsToSave) {
        
        dataManager.saveTvShowsToWatchLater(originalLanguage: dataToSave.originalLanguage,
                                            posterPath: dataToSave.posterPath,
                                            voteCount: dataToSave.voteCount,
                                            voteAverage: dataToSave.voteAverage,
                                            overview: dataToSave.overview,
                                            id: dataToSave.id,
                                            originalName: dataToSave.originalName,
                                            firstAirDate: dataToSave.firstAirDate,
                                            name: dataToSave.name,
                                            backdropPath: dataToSave.backdropPath,
                                            popularity: dataToSave.popularity,
                                            mediaType: dataToSave.mediaType)
    }
    
    func displaySaveStatusAlert(saveSuccess: Bool) {
        
        let statusAlert = StatusAlert()
        statusAlert.appearance.backgroundColor = UIColor.systemGray2
        statusAlert.appearance.blurStyle = .regular
        statusAlert.alertShowingDuration = trendingAlertShowingDuration
        statusAlert.canBePickedOrDismissed = true
        if saveSuccess == true {
            statusAlert.image = UIImage(systemName: "heart.fill")
            statusAlert.title = trendingSaveSuccessString
            statusAlert.message = ""
            statusAlert.showInKeyWindow()
        } else {
            statusAlert.image = UIImage(systemName: "heart.slash.fill")
            statusAlert.title = trendingSaveFailString
            statusAlert.message = ""
            statusAlert.showInKeyWindow()
        }
    }
    
    func setupSaveAnimation(animationView: AnimationView?, button: UIButton) {
        
        if animationView != nil {
            animationView!.frame = button.bounds
            animationView!.contentMode = .scaleAspectFit
            animationView!.loopMode = .playOnce
            animationView!.animationSpeed = 2
            button.addSubview(animationView!)
        }
    }
}
