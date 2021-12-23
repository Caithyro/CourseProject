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
    
    func clearRealm() {}
    
    func saveItems(originalLanguage: String, originalTitle: String, posterPath: String, video: Bool, voteAverage: Double, voteCount: Int, overview: String, releaseDate : String, title : String, id: Int, adult : Bool, backdropPath: String, popularity: Double, mediaType : String) {
        
        let itemData = ResultsToSave(value: ["\(originalLanguage)", "\(originalTitle)", "\(posterPath)", video, voteAverage, voteCount, "\(overview)", "\(releaseDate)", "\(title)", id, adult, "\(backdropPath)", popularity, "\(mediaType)"])
        
        try! realm.write {
            realm.create(ResultsToSave.self, value: itemData)
        }
    }
    
        func getItems() -> [ResultsToSave] {
    
            var itemsArray = [ResultsToSave]()
            let itemsResults = realm.objects(ResultsToSave.self)
            for eachItem in itemsResults {
                itemsArray.append(eachItem)
            }
    
            return itemsArray
        }
}
