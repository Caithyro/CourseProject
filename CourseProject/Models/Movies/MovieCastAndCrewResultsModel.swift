
import Foundation

struct MovieCastAndCrewResultsModel: Codable {
    let id : Int?
    let movieCast : [MovieCastResults]?
    let movieCrew : [MovieCrewResults]?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case movieCast = "cast"
        case movieCrew = "crew"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        movieCast = try values.decodeIfPresent([MovieCastResults].self, forKey: .movieCast)
        movieCrew = try values.decodeIfPresent([MovieCrewResults].self, forKey: .movieCrew)
    }
    
}
