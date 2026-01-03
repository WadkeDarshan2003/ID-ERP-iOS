import Foundation

struct Task: Codable, Identifiable {
    let id: String
    let projectId: String
    let title: String
    let description: String
    let status: String
    let priority: String
    let category: String
    let assignee: String
    let dueDate: Date?
    let createdAt: Date
    
    var dependencies: [String]? // Task IDs
    var subtasks: [Subtask]?
    var comments: [Comment]?
    var approvals: ApprovalStatus?

    enum CodingKeys: String, CodingKey {
        case id
        case projectId = "project_id"
        case title
        case description
        case status
        case priority
        case category
        case assignee
        case dueDate = "due_date"
        case createdAt = "created_at"
        case dependencies
        case subtasks
        case comments
        case approvals
    }
}

struct Subtask: Codable, Identifiable {
    let id: String
    let title: String
    var isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case isCompleted = "is_completed"
    }
}

struct Comment: Codable, Identifiable {
    let id: String
    let userId: String
    let text: String
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case text
        case timestamp
    }
}

struct ApprovalStatus: Codable {
    var client: String // pending, approved, rejected
    var admin: String
    var designer: String
}
