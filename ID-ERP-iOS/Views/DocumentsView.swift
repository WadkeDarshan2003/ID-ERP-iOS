import SwiftUI

struct DocumentsView: View {
    let projectId: String
    @EnvironmentObject var firestoreManager: FirestoreManager
    @EnvironmentObject var authManager: AuthenticationManager
    
    var filteredDocuments: [Document] {
        guard let user = authManager.currentUser else { return [] }
        
        return firestoreManager.documents.filter { doc in
            let role = user.role.rawValue
            let userId = user.id
            let status = doc.approvalStatus ?? "pending"
            
            // Only show to Admin/Designer if pending
            if status == "pending" {
                return role == "Admin" || role == "Designer" || doc.uploadedBy == userId
            }
            // Approved: show to shared users (by ID or Role), client, vendor
            if status == "approved" {
                 let shared = doc.sharedWith ?? []
                 let isShared = shared.contains(userId) || shared.contains(role)
                 return isShared || role == "Admin" || doc.uploadedBy == userId
            }
            // Rejected: only show to admin/designer/uploader
            if status == "rejected" {
                return role == "Admin" || role == "Designer" || doc.uploadedBy == userId
            }
            // Fallback: only show to admin
            return role == "Admin"
        }
    }
    
    var body: some View {
        List {
            if filteredDocuments.isEmpty {
                Text("No documents available")
                    .foregroundColor(.gray)
            } else {
                ForEach(filteredDocuments) { doc in
                    HStack {
                        Image(systemName: "doc.fill")
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(doc.name)
                                .font(.headline)
                            Text(doc.uploadedAt.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Link(destination: URL(string: doc.url)!) {
                            Image(systemName: "arrow.down.circle")
                        }
                    }
                }
            }
        }
        .navigationTitle("Documents")
        .onAppear {
            firestoreManager.fetchDocuments(for: projectId)
        }
    }
}
