import Foundation

struct Document: Codable, Identifiable {
    let id: String
    let name: String
    let url: String
    let type: String
    let size: Int64
    let uploadedBy: String
    let uploadedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case type
        case size
        case uploadedBy = "uploaded_by"
        case uploadedAt = "uploaded_at"
    }
}
