import SwiftUI

struct DocumentsView: View {
    let projectId: String
    @State private var documents: [Document] = [] 
    
    var body: some View {
        List {
            if documents.isEmpty {
                Text("No documents uploaded")
                    .foregroundColor(.gray)
            } else {
                ForEach(documents) { doc in
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
    }
}
