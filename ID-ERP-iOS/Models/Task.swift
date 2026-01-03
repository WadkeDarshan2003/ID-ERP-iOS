import Foundation

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
