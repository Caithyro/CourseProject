
import Foundation
import RealmSwift

struct MoviesResults: Codable {
    let id : Int?
    let releaseDate : String?
    let adult : Bool?
    let backdropPath : String?
    let voteCount : Int?
    let genreIds : [Int]?
    let overview : String?
    let originalLanguage : String?
    let originalTitle : String?
    let posterPath : String?
    let title : String?
    let video : Bool?
    let voteAverage : Double?
    let popularity : Double?
    let mediaType : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case releaseDate = "release_date"
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case voteCount = "vote_count"
        case genreIds = "genre_ids"
        case overview = "overview"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case popularity = "popularity"
        case mediaType = "media_type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
        backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
        voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
        genreIds = try values.decodeIfPresent([Int].self, forKey: .genreIds)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
        originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        video = try values.decodeIfPresent(Bool.self, forKey: .video)
        voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
        popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
    }
    
}

class MoviesResultsToSave: Object {
    
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
