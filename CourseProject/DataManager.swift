//
//  Data&RequestManager.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 22.12.2021.
//

import Foundation
import RealmSwift

class DataManager {
    
    let realm = try! Realm()
    
    func clearRealm() {
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func saveItems(genreIds: [Int], originalLanguage: String, originalTitle: String, originalName: String, posterPath: String, video: Bool, voteAverage: Double, voteCount: Int, overview: String, releaseDate : String, firstAirDate: String, title : String, name: String, id: Int, adult : Bool, backdropPath: String, popularity: Double, mediaType : String) {
        
        let itemData = ResultsToSave(value: [[genreIds], "\(originalLanguage)", "\(originalTitle)", "\(originalName)", "\(posterPath)", video, voteAverage, voteCount, "\(overview)", "\(releaseDate)", "\(firstAirDate)", "\(title)", "\(name)", id, adult, "\(backdropPath)", popularity, "\(mediaType)"])
        
        try! realm.write {
            realm.create(ResultsToSave.self, value: itemData)
        }
    }
    
    func getMovies() -> [ResultsToSave] {
        
        var moviesArray = [ResultsToSave]()
        let moviesResults = realm.objects(ResultsToSave.self).filter("mediaType = %@", "movie")
        for eachMovie in moviesResults {
            moviesArray.append(eachMovie)
        }
        return moviesArray
    }
    
    func getSeries() -> [ResultsToSave] {
        
        var seriesArray = [ResultsToSave]()
        let seriesResults = realm.objects(ResultsToSave.self).filter("mediaType = %@", "tv")
        for eachTvShow in seriesResults {
            seriesArray.append(eachTvShow)
        }
        return seriesArray
    }
}

