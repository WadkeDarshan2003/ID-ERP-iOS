import Foundation

struct Task: Codable, Identifiable {
    let id: String
    let projectId: String
    let title: String
    let description: String?
    let status: String
    var progress: Int? // 0-100
    let priority: String
    let category: String
    let assignee: String // This is often used for the name/id in some parts
    var assigneeId: String? // Aligned with Android taskId
    let dueDate: Date?
    let startDate: Date?
    let createdAt: Date
    
    var dependencies: [String]? // Task IDs
    var subtasks: [Subtask]?
    var comments: [Comment]?
    var documents: [String]? // Document IDs
    var approvals: TaskApprovals?

    enum CodingKeys: String, CodingKey {
        case id
        case projectId
        case title
        case description
        case status
        case progress
        case priority
        case category
        case assignee
        case assigneeId
        case dueDate
        case startDate
        case createdAt
        case dependencies
        case subtasks
        case comments
        case documents
        case approvals
    }
}

struct TaskApprovals: Codable {
    var start: ApprovalFlow
    var completion: ApprovalFlow
}

struct ApprovalFlow: Codable {
    var client: TaskApproval
    var admin: TaskApproval
    var designer: TaskApproval?
}

struct TaskApproval: Codable {
    var status: String // "pending", "approved", "rejected"
    var updatedBy: String?
    var timestamp: String?
}

struct Subtask: Codable, Identifiable {
    let id: String
    let title: String
    var isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case isCompleted
    }
}

struct Comment: Codable, Identifiable {
    let id: String
    let userId: String
    var userName: String?
    let text: String
    let timestamp: Date
    var status: String? // "pending", "done"
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case userName
        case text
        case timestamp
        case status
    }
}
