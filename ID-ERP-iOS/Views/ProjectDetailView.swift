import SwiftUI

struct ProjectDetailView: View {
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
                
                // Quick Actions Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    NavigationLink(destination: ProjectTasksView(projectId: project.id)) {
                        ActionCard(title: "Tasks", icon: "kanban", color: .blue)
                    }
                    
                    NavigationLink(destination: FinancialsView(projectId: project.id)) {
                        ActionCard(title: "Financials", icon: "dollarsign.circle.fill", color: .green)
                    }
                    
                    NavigationLink(destination: MeetingsView(projectId: project.id)) {
                        ActionCard(title: "Meetings", icon: "calendar", color: .purple)
                    }
                    
                    NavigationLink(destination: DocumentsView(projectId: project.id)) {
                        ActionCard(title: "Documents", icon: "doc.fill", color: .orange)
                    }
                }
                .padding()
                
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
        .navigationTitle("Project Overview")
        .navigationBarTitleDisplayMode(.inline)
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
