import Foundation
import RealmSwift

struct Results : Codable {
    
    let genreIds : [Int]?
    let originalLanguage : String?
    let originalTitle : String?
    let originalName: String?
    let posterPath : String?
    let video : Bool?
    let voteAverage : Double?
    let voteCount : Int?
    let overview : String?
    let releaseDate : String?
    let firstAirDate : String?
    let title : String?
    let name: String?
    let id : Int?
    let adult : Bool?
    let backdropPath : String?
    let popularity : Double?
    let mediaType : String?
    
    enum CodingKeys: String, CodingKey {
        
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case posterPath = "poster_path"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case overview = "overview"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case title = "title"
        case name = "name"
        case id = "id"
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case popularity = "popularity"
        case mediaType = "media_type"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        genreIds = try values.decodeIfPresent([Int].self, forKey: .genreIds)
        originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
        originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
        originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
        video = try values.decodeIfPresent(Bool.self, forKey: .video)
        voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
        voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        firstAirDate = try values.decodeIfPresent(String.self, forKey: .firstAirDate)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
        backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
        popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
    }
    
}

class ResultsToSave: Object {
    
    let genreIds = List<Genres>()
    @objc dynamic var originalLanguage = ""
    @objc dynamic var originalTitle = ""
    @objc dynamic var originalName = ""
    @objc dynamic var posterPath = ""
    @objc dynamic var video = false
    @objc dynamic var voteAverage = 0.0
    @objc dynamic var voteCount = 0
    @objc dynamic var overview = ""
    @objc dynamic var releaseDate = ""
    @objc dynamic var firstAirDate = ""
    @objc dynamic var title = ""
    @objc dynamic var name = ""
    @objc dynamic var id = 0
    @objc dynamic var adult = true
    @objc dynamic var backdropPath = ""
    @objc dynamic var popularity = 0.0
    @objc dynamic var mediaType = ""
}

class Genres: Object {
    
    @objc dynamic var genre1 = 0
    @objc dynamic var genre2 = 0
    @objc dynamic var genre3 = 0
    @objc dynamic var genre4 = 0
    @objc dynamic var genre5 = 0
}
