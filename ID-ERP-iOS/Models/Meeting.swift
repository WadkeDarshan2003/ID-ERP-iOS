import Foundation

struct Meeting: Codable, Identifiable {
    let id: String
    let title: String
    let date: String // Match Android date string
    var dateObj: Date? // Optional helper
    var duration: Int? // in minutes
    var location: String?
    let attendees: [String]
    let notes: String
    var type: String?
    var comments: [Comment]?
    var status: String? // Aligned with Android flexibility
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case date
        case duration
        case location
        case attendees
        case notes
        case type
        case comments
        case status
    }
}
