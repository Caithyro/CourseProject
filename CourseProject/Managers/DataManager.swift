//
//  Data&RequestManager.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 22.12.2021.
//

import Foundation
import RealmSwift
import SwiftUI

class DataManager {
    
    static let shared = DataManager()
    weak var watchLaterViewControllerInstance = WatchLaterViewController()
    weak var trendingViewControllerInstance = TrendingViewController()
    
    let realm = try! Realm()
    
    func saveMovies(id: Int, releaseDate: String, adult: Bool, backdropPath: String, voteCount: Int, overview: String, originalLanguage: String, originalTitle: String, posterPath: String, title: String, video: Bool, voteAverage: Double, popularity: Double, mediaType: String) {
        let moviesData = MoviesResultsToSave(value: [id, "\(releaseDate)", adult, "\(backdropPath)", voteCount, "\(overview)", "\(originalLanguage)", "\(originalTitle)", "\(posterPath)", "\(title)", video, voteAverage, popularity, "\(mediaType)"])
        
        try! realm.write {
            realm.create(MoviesResultsToSave.self, value: moviesData, update: .all)
        }
    }
    
    func saveTvShows(originalLanguage : String, posterPath: String, voteCount: Int, voteAverage: Double, overview: String, id: Int, originalName: String, firstAirDate: String, name: String, backdropPath: String, popularity: Double, mediaType: String) {
        let tvShowsData = TvResultsToSave(value: ["\(originalLanguage)", "\(posterPath)", voteCount, voteAverage, "\(overview)", id, "\(originalName)", "\(firstAirDate)", "\(name)", "\(backdropPath)", popularity, "\(mediaType)"])
        
        try! realm.write {
            realm.create(TvResultsToSave.self, value: tvShowsData, update: .all)
        }
    }
    
    func saveMovieCast(adult: Bool, gender: Int, id: Int, knownForDepartment: String, name: String, originalName: String, popularity: Double, profilePath: String, castId: Int, character: String, creditId: String, order: Int) {
        let movieCastData = MovieCastResultsToSave(value: [adult, gender, id, "\(knownForDepartment)", "\(name)", "\(originalName)", popularity, "\(profilePath)", castId, "\(character)", "\(creditId)", order])
        
        try! realm.write {
            realm.create(MovieCastResultsToSave.self, value: movieCastData, update: .all)
        }
    }
    
    func saveTvCast(adult: Bool, gender: Int, id: Int, knownForDepartment: String, name: String, originalName: String, popularity: Double, profilePath: String, character: String, creditId: String, order: Int) {
        let tvCastData = TvCastResultsToSave(value: [adult, gender, id, "\(knownForDepartment)", "\(name)", "\(originalName)", popularity, "\(profilePath)", "\(character)", "\(creditId)", order])
        
        try! realm.write {
            realm.create(TvCastResultsToSave.self, value: tvCastData, update: .all)
        }
    }
    
    func saveMovieTrailers(iso6391: String, iso31661: String, name: String, key: String, site: String, size: Int, type: String, official: Bool, publishedAt: String, id: String) {
        let movieTrailersData = MovieTrailersRelultsToSave(value: ["\(iso6391)", "\(iso31661)", "\(name)", "\(key)", "\(site)", size, "\(type)", official, "\(publishedAt)", "\(id)"])
        
        try! realm.write {
            realm.create(MovieTrailersRelultsToSave.self, value: movieTrailersData, update: .all)
        }
    }
    
    func saveTvTrailers(iso6391: String, iso31661: String, name: String, key: String, site: String, size: Int, type: String, official: Bool, publishedAt: String, id: String) {
        let tvTrailersData = TvTrailersRelultsToSave(value: ["\(iso6391)", "\(iso31661)", "\(name)", "\(key)", "\(site)", size, "\(type)", official, "\(publishedAt)", "\(id)"])
        
        try! realm.write {
            realm.create(TvTrailersRelultsToSave.self, value: tvTrailersData, update: .all)
        }
    }
    
    func saveMoviesToWatchLater(id: Int, releaseDate: String, adult: Bool, backdropPath: String, voteCount: Int, overview: String, originalLanguage: String, originalTitle: String, posterPath: String, title: String, video: Bool, voteAverage: Double, popularity: Double, mediaType: String) {
        let moviesData = MoviesResultsToSaveToWatchLater(value: [id, "\(releaseDate)", adult, "\(backdropPath)", voteCount, "\(overview)", "\(originalLanguage)", "\(originalTitle)", "\(posterPath)", "\(title)", video, voteAverage, popularity, "\(mediaType)"])
        
        do {
            try! realm.write {
                realm.create(MoviesResultsToSaveToWatchLater.self, value: moviesData, update: .all)
            }
            trendingViewControllerInstance?.saveSuccessfull()
        } catch {
            trendingViewControllerInstance?.saveFailed()
        }
    }
    
    func saveTvShowsToWatchLater(originalLanguage : String, posterPath: String, voteCount: Int, voteAverage: Double, overview: String, id: Int, originalName: String, firstAirDate: String, name: String, backdropPath: String, popularity: Double, mediaType: String) {
        let tvShowsData = TvResultsToSaveToWatchLater(value: ["\(originalLanguage)", "\(posterPath)", voteCount, voteAverage, "\(overview)", id, "\(originalName)", "\(firstAirDate)", "\(name)", "\(backdropPath)", popularity, "\(mediaType)"])
        
        do {
            try! realm.write {
                realm.create(TvResultsToSaveToWatchLater.self, value: tvShowsData, update: .all)
            }
            trendingViewControllerInstance?.saveSuccessfull()
        } catch {
            trendingViewControllerInstance?.saveFailed()
        }
    }
    
    func getMovies() -> [MoviesResultsToSave] {
        var moviesArray = [MoviesResultsToSave]()
        let moviesResults = realm.objects(MoviesResultsToSave.self)
        for eachMovie in moviesResults {
            moviesArray.append(eachMovie)
        }
        return moviesArray
    }
    
    func getTvShows() -> [TvResultsToSave] {
        var tvArray = [TvResultsToSave]()
        let tvResults = realm.objects(TvResultsToSave.self)
        for eachTvShow in tvResults {
            tvArray.append(eachTvShow)
        }
        return tvArray
    }
    
    func getMovieCast() -> [MovieCastResultsToSave] {
        var movieCastArray = [MovieCastResultsToSave]()
        let movieCastResults = realm.objects(MovieCastResultsToSave.self)
        for eachMember in movieCastResults {
            movieCastArray.append(eachMember)
        }
        return movieCastArray
    }
    
    func getTvCast() -> [TvCastResultsToSave] {
        var tvCastArray = [TvCastResultsToSave]()
        let tvCastResults = realm.objects(TvCastResultsToSave.self)
        for eachMember in tvCastResults {
            tvCastArray.append(eachMember)
        }
        return tvCastArray
    }
    
    func getMovieTrailers() -> [MovieTrailersRelultsToSave] {
        var movieTrailersArray = [MovieTrailersRelultsToSave]()
        let movieTrailersResults = realm.objects(MovieTrailersRelultsToSave.self).filter("type = %@", "Trailer")
        for eachTrailer in movieTrailersResults {
            movieTrailersArray.append(eachTrailer)
        }
        
        return movieTrailersArray
    }
    
    func getTvTrailers() -> [TvTrailersRelultsToSave] {
        var tvTrailersArray = [TvTrailersRelultsToSave]()
        let tvTrailersResults = realm.objects(TvTrailersRelultsToSave.self).filter("type = %@", "Trailer")
        for eachTrailer in tvTrailersResults {
            tvTrailersArray.append(eachTrailer)
        }
        
        return tvTrailersArray
    }
    
    func getMoviesWatchLaterList() -> [MoviesResultsToSaveToWatchLater] {
        var moviesWatchLaterArray = [MoviesResultsToSaveToWatchLater]()
        let movieWatchLaterResults = realm.objects(MoviesResultsToSaveToWatchLater.self)
        for eachMovie in movieWatchLaterResults {
            moviesWatchLaterArray.append(eachMovie)
        }
        
        return moviesWatchLaterArray
    }
    
    func getTvWatchLaterList() -> [TvResultsToSaveToWatchLater] {
        var tvWatchLaterArray = [TvResultsToSaveToWatchLater]()
        let tvWatchLaterResults = realm.objects(TvResultsToSaveToWatchLater.self)
        for eachTvShow in tvWatchLaterResults {
            tvWatchLaterArray.append(eachTvShow)
        }
        
        return tvWatchLaterArray
    }
    
    func removeMovieFromWatchLater(targetMovie: Int) {
        
        do {
            try realm.write {
                realm.delete(realm.objects(MoviesResultsToSaveToWatchLater.self).filter("id = %@", targetMovie))
            }
        } catch {
            print(error)
        }
        watchLaterViewControllerInstance?.savedMoviesData = DataManager.shared.getMoviesWatchLaterList()
        watchLaterViewControllerInstance?.watchLaterCollectionView.reloadData()
    }
    
    func removeTvFromWatchLater(targetTvShow: Int) {
        
        do {
            try realm.write {
                realm.delete(realm.objects(TvResultsToSaveToWatchLater.self).filter("id = %@", targetTvShow))
            }
        } catch {
            print(error)
        }
        watchLaterViewControllerInstance?.savedSeriesData = DataManager.shared.getTvWatchLaterList()
        watchLaterViewControllerInstance?.watchLaterCollectionView.reloadData()
    }
    
    func clearTrendingMovies() {
        try! realm.write {
            realm.delete(realm.objects(MoviesResultsToSave.self))
        }
    }
    
    func clearTrendingSeries() {
        try! realm.write {
            realm.delete(realm.objects(TvResultsToSave.self))
        }
    }
    
    func clearMovieCast() {
        try! realm.write {
            realm.delete(realm.objects(MovieCastResultsToSave.self))
        }
    }
    
    func clearTvCast() {
        try! realm.write {
            realm.delete(realm.objects(TvCastResultsToSave.self))
        }
    }
    
    func clearMovieTrailers() {
        try! realm.write {
            realm.delete(realm.objects(MovieTrailersRelultsToSave.self))
        }
    }
    
    func clearTvTrailers() {
        try! realm.write {
            realm.delete(realm.objects(TvTrailersRelultsToSave.self))
        }
    }
}

