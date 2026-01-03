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

struct Task: Codable, Identifiable {
    let id: String
    let projectId: String
    let title: String
    let description: String
    let status: String
    let priority: String
    let assignee: String
    let dueDate: Date?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectId = "project_id"
        case title
        case description
        case status
        case priority
        case assignee
        case dueDate = "due_date"
        case createdAt = "created_at"
    }
}
