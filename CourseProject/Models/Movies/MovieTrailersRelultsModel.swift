
import Foundation

struct MovieTrailersRelultsModel: Codable {
	let id : Int?
	let results : [MovieTrailersRelults]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case results = "results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		results = try values.decodeIfPresent([MovieTrailersRelults].self, forKey: .results)
	}

}
