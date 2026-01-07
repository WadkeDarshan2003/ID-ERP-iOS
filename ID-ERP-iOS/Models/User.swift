import Foundation

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let name: String
    let role: String
    let phone: String?
    let avatar: String?
    var tenantId: String?
    var tenantIds: [String]?
    var company: String?
    var specialty: String?
    var authMethod: String? // "email" or "phone"
    
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
