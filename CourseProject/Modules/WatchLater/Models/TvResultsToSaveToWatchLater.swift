//
//  TvResultsToSaveToWatchLater.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 23.01.2022.
//

import Foundation
import RealmSwift

class TvResultsToSaveToWatchLater: Object {
    
    @objc dynamic var originalLanguage = ""
    @objc dynamic var posterPath = ""
    @objc dynamic var voteCount = 0
    @objc dynamic var voteAverage = 0.0
    @objc dynamic var overview = ""
    @objc dynamic var id = 0
    @objc dynamic var originalName = ""
    @objc dynamic var firstAirDate = ""
    @objc dynamic var name = ""
    @objc dynamic var backdropPath = ""
    @objc dynamic var popularity = 0.0
    @objc dynamic var mediaType = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
