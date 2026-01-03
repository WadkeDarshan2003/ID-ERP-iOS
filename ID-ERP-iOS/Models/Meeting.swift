import Foundation

struct Meeting: Codable, Identifiable {
    let id: String
    let title: String
    let date: Date
    let duration: Int // in minutes
    let location: String
    let attendees: [String]
    let notes: String?
    let status: MeetingStatus
    
    enum MeetingStatus: String, Codable {
        case scheduled
        case completed
        case cancelled
    }
}
