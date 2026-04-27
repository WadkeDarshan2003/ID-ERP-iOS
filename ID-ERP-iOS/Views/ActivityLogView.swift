import SwiftUI

struct ActivityLogView: View {
    let projectId: String
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        // Role-based access: Only Admin, Designer can view
        if let userRole = authManager.currentUser?.role,
           (userRole == "Admin" || userRole == "Designer") {
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
        } else {
            VStack(spacing: 20) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.red)
                
                Text("Access Denied")
                    .font(.headline)
                
                Text("You don't have permission to view activity logs.")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationTitle("Timeline")
        }
    }
}
