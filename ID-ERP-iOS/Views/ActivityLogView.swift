import SwiftUI

struct ActivityLogView: View {
    let projectId: String
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        List {
            if firestoreManager.activityLogs.isEmpty {
                Text("No activity recorded")
                    .foregroundColor(.gray)
            } else {
                ForEach(firestoreManager.activityLogs) { log in
                    HStack(alignment: .top, spacing: 12) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 8, height: 8)
                            .padding(.top, 6)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(log.action)
                                .fontWeight(.semibold)
                            
                            Text(log.details)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(log.timestamp.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Timeline")
        .onAppear {
            firestoreManager.fetchActivityLogs(for: projectId)
        }
    }
}
