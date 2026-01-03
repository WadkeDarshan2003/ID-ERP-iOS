import Foundation

struct Project: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let status: String
    let startDate: Date
    let endDate: Date?
    let budget: Double?
    let owner: String
    let team: [String]
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case status
        case startDate = "start_date"
        case endDate = "end_date"
        case budget
        case owner
        case team
        case createdAt = "created_at"
    }
}
