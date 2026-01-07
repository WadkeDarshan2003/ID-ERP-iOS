import Foundation

struct Document: Codable, Identifiable {
    let id: String
    let name: String
    let url: String
    let type: String // image, pdf, cad, other
    var size: Int64?
    let uploadedBy: String
    var uploadDate: String?
    var uploadedAt: Date?
    
    var sharedWith: [String]?
    var comments: [Comment]?
    var approvalStatus: String? // pending, approved, rejected
    var approvedBy: String?
    var rejectedBy: String?
    var approvalDate: String?
    var rejectionDate: String?
    
    var clientApprovalStatus: String?
    var clientApprovedBy: String?
    var clientApprovedDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case type
        case size
        case uploadedBy
        case uploadDate
        case uploadedAt
        case sharedWith
        case comments
        case approvalStatus
        case approvedBy
        case rejectedBy
        case approvalDate
        case rejectionDate
        case clientApprovalStatus
        case clientApprovedBy
        case clientApprovedDate
    }
}
