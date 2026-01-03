import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class MeetingManager: ObservableObject {
    static let shared = MeetingManager()
    private let db = Firestore.firestore()
    
    @Published var meetings: [Meeting] = []
    
    func fetchMeetings(for projectId: String) {
        db.collection("projects").document(projectId).collection("meetings")
            .order(by: "date", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self?.meetings = documents.compactMap { try? .data(as: Meeting.self) }
            }
    }
    
    func scheduleMeeting(projectId: String, meeting: Meeting) {
        try? db.collection("projects").document(projectId).collection("meetings").document(meeting.id).setData(from: meeting)
    }
}
