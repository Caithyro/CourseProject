//
//  TrendingViewControllerViewModel.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 23.01.2022.
//

import Foundation

class TrendingViewControllerViewModel {
    
    func loadMovies(searchPerformed: Bool, query: String) {
        
        if searchPerformed == true {
            RequestManager.shared.movieSearchRequest(query: query)
        } else {
            loadMoviesListFromRealm()
        }
    }
    
    func loadTvShows(searchPerformed: Bool, query: String) {
        
        if searchPerformed == true {
            RequestManager.shared.tvSearchRequest(query: query)
        } else {
            loadTvShowsListFromRealm()
        }
    }
    
    // MARK: - Private
    
    private func loadMoviesListFromRealm() {
        
        var savedMoviesArray: [MoviesResultsToSave] = []
        RequestManager.shared.requestMovies()
        savedMoviesArray = DataManager.shared.getMoviesFromRealm()
    }
    
    private func loadTvShowsListFromRealm() {
        
        var savedSeriesArray: [TvResultsToSave] = []
        RequestManager.shared.requestTvShows()
        savedSeriesArray = DataManager.shared.getTvShowsFromRealm()
    }
}
