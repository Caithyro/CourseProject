//
//  DetailsViewControllerViewModel.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 23.01.2022.
//

import Foundation

class DetailsViewControllerViewModel {
    
    static let shared = DetailsViewControllerViewModel()
    let originalLanguages: [String: String] = ["en" : "English", "es" : "Spanish", "ru" : "Russian",
                                               "ko": "Korean", "it" : "Italian", "ja" : "Japanese",
                                               "fr" : "French", "ml" : "Malayalam", "pl" : "Polish", "id" : "Indonesian", "nil" : "Unknown"]
    
    var savedMovieCast: [MovieCastResultsToSave] = []
    var savedTvCast: [TvCastResultsToSave] = []
    var savedMovieTrailers: [MovieTrailersRelultsToSave] = []
    var savedTvTrailers: [TvTrailersRelultsToSave] = []
    var backgroundImageViewURL: String = ""
    var detailsTitle: String = ""
    var detailsPosterURL: String = ""
    var detailsDescription: String = ""
    var detailsAverageVote: Double = 0.0
    var detailsVoteCount: Int = 0
    var detailsOriginalLanguage: String = ""
    var targetMovie: Int = 0
    var targetTvShow: Int = 0
    var movieOrTvShow: Int = 0
    var videoId: String = ""
    
    func loadTrailersAndCast(movieOrTvShow: Int, targetMovie: Int, targetTvShow: Int, completion: @escaping(() -> ())) {
        
        if movieOrTvShow == 0 {
            loadMovieCastAndTrailers(targetMovie: targetMovie, completion: {
                self.videoId = self.savedMovieTrailers.first?.key ?? ""
            })
        } else {
            loadTvShowCastAndTrailers(targetTvShow: targetTvShow)
        }
        completion()
    }
    
    //MARK: - Private
    
    private func loadMovieCastAndTrailers(targetMovie: Int, completion: @escaping (() -> ())) {
        
        RequestManager.shared.requestMovieCast(targetMovieId: targetMovie)
        RequestManager.shared.requestMovieTrailers(targetMovie: targetMovie)
        completion()
    }
    
    private func loadTvShowCastAndTrailers(targetTvShow: Int) {
        
        RequestManager.shared.requestTvCast(targetShowId: targetTvShow)
        RequestManager.shared.requestTvTrailers(targetShow: targetTvShow)
        videoId = savedTvTrailers.first?.key ?? ""
    }
}
