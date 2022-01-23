//
//  WatchLaterViewControllerViewModel.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 23.01.2022.
//

import Foundation

class WatchLaterViewControllerViewModel {
    
    var savedMoviesData: [MoviesResultsToSaveToWatchLater] = []
    var savedSeriesData: [TvResultsToSaveToWatchLater] = []
    
    func getMediaDataFromRealm(completion: @escaping(() -> ())) {
        
        self.savedMoviesData = DataManager.shared.getMoviesWatchLaterList()
        self.savedSeriesData = DataManager.shared.getTvWatchLaterList()
        completion()
    }
    
    func getMoviesFromWatchLater(completion: @escaping(() -> ())) {
        
        self.savedMoviesData = DataManager.shared.getMoviesWatchLaterList()
        completion()
    }
    
    func getTvShowsFromWatchLater(completion: @escaping(() -> ())) {
        
        self.savedSeriesData = DataManager.shared.getTvWatchLaterList()
        completion()
    }
    
    func removeMovieFromWatchLater(targetMovie: Int) {
        
        DataManager.shared.removeMovieFromWatchLater(targetMovie: targetMovie)
    }
    
    func removeTvShowFromWatchLater(targetTvShow: Int) {
        
        DataManager.shared.removeTvFromWatchLater(targetTvShow: targetTvShow)
    }
}
