//
//  Data&RequestManager.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 22.12.2021.
//

import Foundation
import RealmSwift

class DataManager {
    
    static let shared = DataManager()
    
    let moviesRealm = try! Realm()
    let seriesRealm = try! Realm()
    let movieCastRealm = try! Realm()
    let tvCastRealm = try! Realm()
    
    func saveMovies(id: Int, releaseDate: String, adult: Bool, backdropPath: String, voteCount: Int, overview: String, originalLanguage: String, originalTitle: String, posterPath: String, title: String, video: Bool, voteAverage: Double, popularity: Double, mediaType: String) {
        let moviesData = MoviesResultsToSave(value: [id, "\(releaseDate)", adult, "\(backdropPath)", voteCount, "\(overview)", "\(originalLanguage)", "\(originalTitle)", "\(posterPath)", "\(title)", video, voteAverage, popularity, "\(mediaType)"])
        
        try! moviesRealm.write {
            moviesRealm.create(MoviesResultsToSave.self, value: moviesData)
        }
    }
    
    func saveTvShows(originalLanguage : String, posterPath: String, voteCount: Int, voteAverage: Double, overview: String, id: Int, originalName: String, firstAirDate: String, name: String, backdropPath: String, popularity: Double, mediaType: String) {
        let tvShowsData = TvResultsToSave(value: ["\(originalLanguage)", "\(posterPath)", voteCount, voteAverage, "\(overview)", id, "\(originalName)", "\(firstAirDate)", "\(name)", "\(backdropPath)", popularity, "\(mediaType)"])
        
        try! seriesRealm.write {
            seriesRealm.create(TvResultsToSave.self, value: tvShowsData)
        }
    }
    
    func saveMovieCast(adult: Bool, gender: Int, id: Int, knownForDepartment: String, name: String, originalName: String, popularity: Double, profilePath: String, castId: Int, character: String, creditId: String, order: Int) {
        let movieCastData = MovieCastResultsToSave(value: [adult, gender, id, "\(knownForDepartment)", "\(name)", "\(originalName)", popularity, "\(profilePath)", castId, "\(character)", "\(creditId)", order])
        
        try! movieCastRealm.write {
            movieCastRealm.create(MovieCastResultsToSave.self, value: movieCastData, update: .all)
        }
    }
    
    func saveTvCast(adult: Bool, gender: Int, id: Int, knownForDepartment: String, name: String, originalName: String, popularity: Double, profilePath: String, character: String, creditId: String, order: Int) {
        let tvCastData = TvCastResultsToSave(value: [adult, gender, id, "\(knownForDepartment)", "\(name)", "\(originalName)", popularity, "\(profilePath)", "\(character)", "\(creditId)", order])
        
        try! tvCastRealm.write {
            movieCastRealm.create(TvCastResultsToSave.self, value: tvCastData, update: .all)
        }
    }

    
    func getMovies() -> [MoviesResultsToSave] {
        var moviesArray = [MoviesResultsToSave]()
        let moviesResults = moviesRealm.objects(MoviesResultsToSave.self)
        for eachMovie in moviesResults {
            moviesArray.append(eachMovie)
        }
        return moviesArray
    }
    
    func getSeries() -> [TvResultsToSave] {
        var seriesArray = [TvResultsToSave]()
        let seriesResults = seriesRealm.objects(TvResultsToSave.self)
        for eachTvShow in seriesResults {
            seriesArray.append(eachTvShow)
        }
        return seriesArray
    }
    
    func getMovieCast() -> [MovieCastResultsToSave] {
        
        var movieCastArray = [MovieCastResultsToSave]()
        let movieCastResults = movieCastRealm.objects(MovieCastResultsToSave.self)
            for eachMember in movieCastResults {
                movieCastArray.append(eachMember)
            }
        return movieCastArray
    }
    
    func getTvCast() -> [TvCastResultsToSave] {
        
        var tvCastArray = [TvCastResultsToSave]()
        let tvCastResults = tvCastRealm.objects(TvCastResultsToSave.self)
            for eachMember in tvCastResults {
                tvCastArray.append(eachMember)
            }
        return tvCastArray
    }
    
    func clearMoviesRealm() {
        
        try! moviesRealm.write {
            moviesRealm.deleteAll()
        }
    }
}

