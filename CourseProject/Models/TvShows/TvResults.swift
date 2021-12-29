
import Foundation
import RealmSwift

struct TvResults: Codable {
	let genreIds : [Int]?
	let originalLanguage : String?
	let posterPath : String?
	let voteCount : Int?
	let voteAverage : Double?
	let overview : String?
	let id : Int?
	let originalName : String?
	let firstAirDate : String?
	let originCountry : [String]?
	let name : String?
	let backdropPath : String?
	let popularity : Double?
	let mediaType : String?

	enum CodingKeys: String, CodingKey {

		case genreIds = "genre_ids"
		case originalLanguage = "original_language"
		case posterPath = "poster_path"
		case voteCount = "vote_count"
		case voteAverage = "vote_average"
		case overview = "overview"
		case id = "id"
		case originalName = "original_name"
		case firstAirDate = "first_air_date"
		case originCountry = "origin_country"
		case name = "name"
		case backdropPath = "backdrop_path"
		case popularity = "popularity"
		case mediaType = "media_type"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        genreIds = try values.decodeIfPresent([Int].self, forKey: .genreIds)
        originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
        voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
        voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
		overview = try values.decodeIfPresent(String.self, forKey: .overview)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
        originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
        firstAirDate = try values.decodeIfPresent(String.self, forKey: .firstAirDate)
        originCountry = try values.decodeIfPresent([String].self, forKey: .originCountry)
		name = try values.decodeIfPresent(String.self, forKey: .name)
        backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
		popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
	}

}

class TvResultsToSave: Object {
    
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
