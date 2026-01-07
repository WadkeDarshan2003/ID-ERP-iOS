import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    var initialTab: ProjectTab?
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedTab: ProjectTab = .overview

    enum ProjectTab: String {
        case overview, tasks, financials, meetings, documents, team
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab Picker
            Picker("Tab", selection: $selectedTab) {
                Text("Overview").tag(ProjectTab.overview)
                Text("Tasks").tag(ProjectTab.tasks)
                // Only show financials for privileged roles
                if let role = authManager.currentUser?.role, (role == "Admin" || role == "Designer") {
                    Text("Financials").tag(ProjectTab.financials)
                }
                Text("Documents").tag(ProjectTab.documents)
            }
            .pickerStyle(.segmented)
            .padding()

            switch selectedTab {
            case .overview:
                ProjectOverviewTab(project: project)
            case .tasks:
                ProjectTasksView(projectId: project.id)
            case .financials:
                FinancialsView(projectId: project.id)
            case .meetings:
                MeetingsView(projectId: project.id)
            case .documents:
                DocumentsView(projectId: project.id)
            case .team:
                Text("Team View") // Placeholder
            }
        }
        .onAppear {
            if let initial = initialTab {
                selectedTab = initial
            }
        }
        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProjectOverviewTab: View {
    let project: Project
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(project.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(project.description)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // Details Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Project Details")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        DetailRow(label: "Status", value: project.status)
                        DetailRow(label: "Type", value: project.type.rawValue)
                        DetailRow(label: "Category", value: project.category.rawValue)
                        DetailRow(label: "Start Date", value: project.startDate.formatted(date: .abbreviated, time: .omitted))
                        
                        if let budget = project.budget {
                            DetailRow(label: "Budget", value: String(format: "$%.2f", budget))
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

struct ActionCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
