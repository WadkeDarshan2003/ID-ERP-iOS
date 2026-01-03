import Foundation

struct ActivityLog: Codable, Identifiable {
    let id: String
    let userId: String
    let action: String
    let details: String
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case action
        case details
        case timestamp
    }
}
