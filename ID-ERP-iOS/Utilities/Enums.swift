import Foundation

// MARK: - API Enumerations
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum SortOrder: String {
    case ascending = "asc"
    case descending = "desc"
}

// MARK: - User Enumerations
enum UserRole: String, CaseIterable {
    case admin = "Admin"
    case designer = "Designer"
    case vendor = "Vendor"
    case client = "Client"
    
    var displayName: String {
        return self.rawValue
    }
}

// MARK: - Project Enumerations
enum ProjectStatus: String, CaseIterable {
    case discovery = "Discovery"
    case planning = "Planning"
    case execution = "Execution"
    case completed = "Completed"
    case onHold = "On Hold"
    
    var displayName: String {
        return self.rawValue
    }
}

// MARK: - Task Enumerations
enum TaskStatus: String, CaseIterable {
    case todo = "To Do"
    case inProgress = "In Progress"
    case review = "Review"
    case done = "Done"
    case overdue = "Overdue"
    case aborted = "Aborted"
    case onHold = "On Hold"
}

enum TaskPriority: String, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
}
        case .archived:
            return "Archived"
        case .onHold:
            return "On Hold"
        }
    }
}

// MARK: - Task Enumerations
enum TaskStatus: String, CaseIterable {
    case todo = "todo"
    case inProgress = "in_progress"
    case review = "review"
    case completed = "completed"
    
    var displayName: String {
        switch self {
        case .todo:
            return "To Do"
        case .inProgress:
            return "In Progress"
        case .review:
            return "In Review"
        case .completed:
            return "Completed"
        }
    }
}

enum TaskPriority: String, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
    
    var displayName: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        case .critical:
            return "Critical"
        }
    }
}

// MARK: - Notification Enumerations
enum NotificationType: String, CaseIterable {
    case projectUpdate = "project_update"
    case taskAssigned = "task_assigned"
    case taskCompleted = "task_completed"
    case messageReceived = "message_received"
    case systemAlert = "system_alert"
    case meeting = "meeting"
    case financeUpdate = "finance_update"
    
    var displayName: String {
        switch self {
        case .projectUpdate:
            return "Project Update"
        case .taskAssigned:
            return "Task Assigned"
        case .taskCompleted:
            return "Task Completed"
        case .messageReceived:
            return "Message"
        case .systemAlert:
            return "System Alert"
        case .meeting:
            return "Meeting"
        case .financeUpdate:
            return "Finance Update"
        }
    }
}

// MARK: - Filter Enumerations
enum FilterType {
    case status(String)
    case priority(String)
    case assignee(String)
    case dateRange(Date, Date)
    case search(String)
}
