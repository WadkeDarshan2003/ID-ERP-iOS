import SwiftUI

struct MeetingsView: View {
    let projectId: String
    @StateObject private var meetingManager = MeetingManager.shared
    
    var body: some View {
        List {
            ForEach(meetingManager.meetings) { meeting in
                VStack(alignment: .leading, spacing: 8) {
                    Text(meeting.title)
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(meeting.date.formatted(date: .abbreviated, time: .shortened))
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text(meeting.location)
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Meetings")
        .onAppear {
            meetingManager.fetchMeetings(for: projectId)
        }
    }
}
