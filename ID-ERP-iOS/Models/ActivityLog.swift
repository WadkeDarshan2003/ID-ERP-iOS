import Foundation

struct ActivityLog: Codable, Identifiable {
    let id: String
    let userId: String
    let action: String // e.g., "Created Task", "Approved Phase 1"
    let details: String
    let timestamp: Date
    var type: String? // "info", "success", "warning", "creation"
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case action
        case details
        case timestamp
        case type
    }
}
