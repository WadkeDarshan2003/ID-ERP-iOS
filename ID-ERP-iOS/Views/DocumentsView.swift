import SwiftUI

struct DocumentsView: View {
    let projectId: String
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        List {
            if firestoreManager.documents.isEmpty {
                Text("No documents uploaded")
                    .foregroundColor(.gray)
            } else {
                ForEach(firestoreManager.documents) { doc in
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
