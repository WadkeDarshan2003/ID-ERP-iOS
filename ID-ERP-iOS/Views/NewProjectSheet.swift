import SwiftUI

struct NewProjectSheet: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var description = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Project Details") {
                    TextField("Project Name", text: $name)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newProject = Project(
                            id: UUID().uuidString,
                            name: name,
                            description: description,
                            status: "active",
                            startDate: Date(),
                            endDate: nil,
                            budget: nil,
                            owner: "current_user",
                            team: [],
                            createdAt: Date()
                        )
                        firestoreManager.createProject(newProject)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
