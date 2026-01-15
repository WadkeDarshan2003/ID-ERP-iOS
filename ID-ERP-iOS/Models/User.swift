import Foundation

enum Role: String, Codable {
    case admin = "Admin"
    case designer = "Designer"
    case vendor = "Vendor"
    case client = "Client"
}

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let name: String
    let role: Role
    let phone: String?
    let avatar: String?
    var tenantId: String?
    var tenantIds: [String]? // For vendors/designers: array of tenant IDs they can access
    var company: String? // For vendors
    var specialty: String? // For designers/vendors
    var authMethod: String? // "email" or "phone"
    var createdBy: String? // ID of the user who created this user
    
    // Vendor project metrics
    var projectMetrics: [String: ProjectMetric]?
    
    let createdAt: Date
    let lastLogin: Date?
    let isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case role
        case phone
        case avatar
        case tenantId
        case tenantIds
        case company
        case specialty
        case authMethod
        case createdBy
        case projectMetrics
        case createdAt
        case lastLogin
        case isActive
    }
}

struct ProjectMetric: Codable {
    let projectName: String
    let taskCount: Int
    let netAmount: Double
}
