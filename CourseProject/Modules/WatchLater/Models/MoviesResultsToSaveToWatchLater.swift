//
//  MoviesResultsToSaveToWatchLater.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 23.01.2022.
//

import Foundation
import RealmSwift

class MoviesResultsToSaveToWatchLater: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var releaseDate = ""
    @objc dynamic var adult = true
    @objc dynamic var backdropPath = ""
    @objc dynamic var voteCount = 0
    @objc dynamic var overview = ""
    @objc dynamic var originalLanguage = ""
    @objc dynamic var originalTitle = ""
    @objc dynamic var posterPath = ""
    @objc dynamic var title = ""
    @objc dynamic var video = false
    @objc dynamic var voteAverage = 0.0
    @objc dynamic var popularity = 0.0
    @objc dynamic var mediaType = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
