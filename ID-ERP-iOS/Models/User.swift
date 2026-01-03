import Foundation

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let name: String
    let role: String
    let department: String?
    let avatar: String?
    let createdAt: Date
    let lastLogin: Date?
    let isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case role
        case department
        case avatar
        case createdAt = "created_at"
        case lastLogin = "last_login"
        case isActive = "is_active"
    }
}
