import Foundation

struct AppConstants {
    
    // MARK: - API Configuration
    static let firebaseProjectID = "your-firebase-project-id"
    static let firebaseRegion = "us-central1"
    
    // MARK: - App Info
    static let appName = "ID ERP"
    static let appVersion = "1.0.0"
    static let bundleID = "com.iderp.ios"
    static let minimumOSVersion = "14.0"
    
    // MARK: - Firestore Collections
    struct Collections {
        static let users = "users"
        static let projects = "projects"
        static let tasks = "tasks"
        static let notifications = "notifications"
        static let meetings = "meetings"
        static let finances = "finances"
    }
    
    // MARK: - Database Fields
    struct Fields {
        static let id = "id"
        static let email = "email"
        static let name = "name"
        static let role = "role"
        static let createdAt = "created_at"
        static let updatedAt = "updated_at"
        static let isActive = "is_active"
    }
    
    // MARK: - User Roles
    struct UserRoles {
        static let admin = "admin"
        static let manager = "manager"
        static let user = "user"
        static let guest = "guest"
    }
    
    // MARK: - Project Status
    struct ProjectStatus {
        static let active = "active"
        static let completed = "completed"
        static let archived = "archived"
        static let onHold = "on_hold"
    }
    
    // MARK: - Task Status
    struct TaskStatus {
        static let todo = "todo"
        static let inProgress = "in_progress"
        static let review = "review"
        static let completed = "completed"
    }
    
    // MARK: - Task Priority
    struct TaskPriority {
        static let low = "low"
        static let medium = "medium"
        static let high = "high"
        static let critical = "critical"
    }
    
    // MARK: - Error Messages
    struct ErrorMessages {
        static let networkError = "Network connection failed. Please try again."
        static let invalidEmail = "Please enter a valid email address."
        static let weakPassword = "Password must be at least 6 characters."
        static let loginFailed = "Login failed. Please check your credentials."
        static let registrationFailed = "Registration failed. Please try again."
        static let fetchFailed = "Failed to fetch data. Please try again."
        static let saveFailed = "Failed to save changes. Please try again."
        static let deleteFailed = "Failed to delete item. Please try again."
        static let unknownError = "An unknown error occurred. Please try again."
    }
    
    // MARK: - Success Messages
    struct SuccessMessages {
        static let loginSuccess = "Login successful!"
        static let registrationSuccess = "Registration successful!"
        static let updateSuccess = "Updated successfully!"
        static let deleteSuccess = "Deleted successfully!"
        static let saveSuccess = "Saved successfully!"
    }
    
    // MARK: - Timeouts
    struct Timeouts {
        static let networkRequest: TimeInterval = 30
        static let imageCache: TimeInterval = 3600 // 1 hour
        static let sessionTimeout: TimeInterval = 900 // 15 minutes
    }
    
    // MARK: - Pagination
    struct Pagination {
        static let defaultPageSize = 20
        static let maxPageSize = 100
    }
    
    // MARK: - Cache
    struct Cache {
        static let userCacheKey = "cached_user"
        static let projectsCacheKey = "cached_projects"
        static let tasksCacheKey = "cached_tasks"
        static let imageCache = "image_cache"
    }
}
