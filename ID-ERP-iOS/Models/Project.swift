import Foundation

struct Project: Codable, Identifiable {
    let id: String
    var tenantId: String?
    let name: String
    let description: String
    let status: String
    let type: ProjectType
    let category: ProjectCategory
    let startDate: Date
    let endDate: Date?
    var deadline: Date? // Aligned with Android deadline
    let budget: Double?
    var initialBudget: Double?
    let owner: String? // Admin ID
    var createdBy: String?
    var createdAt: Date
    var updatedBy: String?
    var updatedAt: Date?
    
    let clientId: String
    var clientIds: [String]?
    let leadDesignerId: String
    var teamMembers: [String]?
    var team: [String]? // Array of User IDs
    var vendorIds: [String]?
    var hiddenVendors: [String]?
    
    let thumbnail: String?
    var designerChargePercentage: Double?
    
    // Sub-collections / Embedded arrays
    var meetings: [Meeting]?
    var documents: [Document]?
    var financials: [FinancialRecord]?
    var activityLog: [ActivityLog]?
    var tasks: [Task]?

    enum CodingKeys: String, CodingKey {
        case id
        case tenantId
        case name
        case description
        case status
        case type
        case category
        case startDate
        case endDate
        case deadline
        case budget
        case initialBudget
        case owner
        case createdBy
        case createdAt
        case updatedBy
        case updatedAt
        case clientId
        case clientIds
        case leadDesignerId
        case teamMembers
        case team
        case vendorIds
        case hiddenVendors
        case thumbnail
        case designerChargePercentage
        case meetings
        case documents
        case financials
        case activityLog
        case tasks
    }
}

enum ProjectType: String, Codable {
    case designing = "Designing"
    case turnkey = "Turnkey"
}

enum ProjectCategory: String, Codable {
    case residential = "Residential"
    case commercial = "Commercial"
}
