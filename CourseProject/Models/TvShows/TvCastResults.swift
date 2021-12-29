
import Foundation
import RealmSwift

struct TvCastResults: Codable {
	let adult : Bool?
	let gender : Int?
	let id : Int?
	let knownForDepartment : String?
	let name : String?
	let originalName : String?
	let popularity : Double?
	let profilePath : String?
	let character : String?
	let creditId : String?
	let order : Int?

	enum CodingKeys: String, CodingKey {

		case adult = "adult"
		case gender = "gender"
		case id = "id"
		case knownForDepartment = "known_for_department"
		case name = "name"
		case originalName = "original_name"
		case popularity = "popularity"
		case profilePath = "profile_path"
		case character = "character"
		case creditId = "credit_id"
		case order = "order"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
		gender = try values.decodeIfPresent(Int.self, forKey: .gender)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
        knownForDepartment = try values.decodeIfPresent(String.self, forKey: .knownForDepartment)
		name = try values.decodeIfPresent(String.self, forKey: .name)
        originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
		popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        profilePath = try values.decodeIfPresent(String.self, forKey: .profilePath)
		character = try values.decodeIfPresent(String.self, forKey: .character)
        creditId = try values.decodeIfPresent(String.self, forKey: .creditId)
		order = try values.decodeIfPresent(Int.self, forKey: .order)
	}

}

class TvCastResultsToSave: Object {
    
    @objc dynamic var adult = false
    @objc dynamic var gender = 0
    @objc dynamic var id = 0
    @objc dynamic var knownForDepartment = ""
    @objc dynamic var name = ""
    @objc dynamic var originalName = ""
    @objc dynamic var popularity = 0.0
    @objc dynamic var profilePath = ""
    @objc dynamic var character = ""
    @objc dynamic var creditId = ""
    @objc dynamic var order = 0
    
    override static func primaryKey() -> String? {
        return "order"
    }
}
