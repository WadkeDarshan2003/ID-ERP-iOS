import SwiftUI

struct NewProjectSheet: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var description = ""
    @State private var initialName = ""
    @State private var initialDescription = ""
    @State private var showingDismissAlert = false
    
    var hasUnsavedChanges: Bool {
        name != initialName || description != initialDescription
    }
    
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
                    Button("Cancel") {
                        if hasUnsavedChanges {
                            showingDismissAlert = true
                        } else {
                            dismiss()
                        }
                    }
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
            .alert("Unsaved Changes", isPresented: $showingDismissAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Don't Save", role: .destructive) {
                    dismiss()
                }
                Button("Save & Exit") {
                    saveProject()
                }
            } message: {
                Text("You have unsaved changes. Do you want to save before closing?")
            }
        }
    }
    
    private func saveProject() {
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
        dismiss()               firestoreManager.createProject(newProject)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
