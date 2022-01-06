
import Foundation

struct TvCastAndCrewResultsModel: Codable {
    let id : Int?
    let tvCast : [TvCastResults]?
    let tvCrew : [TvCrewResults]?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case tvCast = "cast"
        case tvCrew = "crew"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        tvCast = try values.decodeIfPresent([TvCastResults].self, forKey: .tvCast)
        tvCrew = try values.decodeIfPresent([TvCrewResults].self, forKey: .tvCrew)
    }
    
}
