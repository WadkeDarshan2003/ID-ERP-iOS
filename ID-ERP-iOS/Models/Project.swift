import Foundation

struct Project: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let status: String
    let type: ProjectType
    let category: ProjectCategory
    let startDate: Date
    let endDate: Date?
    let budget: Double?
    let owner: String // Admin ID
    let clientId: String
    let leadDesignerId: String
    let team: [String] // Array of User IDs
    let thumbnail: String?
    let createdAt: Date
    
    // Sub-collections / Embedded arrays
    var meetings: [Meeting]?
    var documents: [Document]?
    var financials: [FinancialRecord]?
    var activityLog: [ActivityLog]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case status
        case type
        case category
        case startDate = "start_date"
        case endDate = "end_date"
        case budget
        case owner
        case clientId = "client_id"
        case leadDesignerId = "lead_designer_id"
        case team
        case thumbnail
        case createdAt = "created_at"
        case meetings
        case documents
        case financials
        case activityLog = "activity_log"
    }
}

enum ProjectType: String, Codable {
    case designing = "Designing"
    case execution = "Execution"
    case consultation = "Consultation"
}

enum ProjectCategory: String, Codable {
    case residential = "Residential"
    case commercial = "Commercial"
    case hospitality = "Hospitality"
}
