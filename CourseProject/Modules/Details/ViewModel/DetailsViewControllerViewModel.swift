//
//  DetailsViewControllerViewModel.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 23.01.2022.
//

import Foundation

class DetailsViewControllerViewModel {
    
    let requestManager = RequestManager.shared
    
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
                completion()
            })
        } else {
            loadTvShowCastAndTrailers(targetTvShow: targetTvShow, completion: {
                completion ()
            })
        }
    }
    
    //MARK: - Private
    
    private func loadMovieCastAndTrailers(targetMovie: Int, completion: @escaping(() -> ())) {
        
        requestManager.requestMovieTrailers(targetMovie: targetMovie,
                                            completion: { movieTrailerKey in
            self.videoId = movieTrailerKey
        })
        requestManager.requestMovieCast(targetMovieId: targetMovie,
                                        completion: { movieCast in
            self.savedMovieCast = movieCast
            completion()
        })
    }
    
    private func loadTvShowCastAndTrailers(targetTvShow: Int, completion: @escaping(() -> ())) {
        
        requestManager.requestTvTrailers(targetShow: targetTvShow,
                                         completion: { tvShowTrailerKey in
            self.videoId = tvShowTrailerKey
        })
        requestManager.requestTvCast(targetShowId: targetTvShow,
                                     completion: {tvCast in
            self.savedTvCast = tvCast
            completion()
        })
    }
}
