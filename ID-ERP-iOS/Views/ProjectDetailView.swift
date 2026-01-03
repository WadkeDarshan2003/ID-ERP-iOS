import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(project.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(label: "Status", value: project.status)
                    DetailRow(label: "Owner", value: project.owner)
                    DetailRow(label: "Start Date", value: project.startDate.formatted(date: .abbreviated, time: .omitted))
                    
                    if let endDate = project.endDate {
                        DetailRow(label: "End Date", value: endDate.formatted(date: .abbreviated, time: .omitted))
                    }
                    
                    if let budget = project.budget {
                        DetailRow(label: "Budget", value: "$\(String(format: "%.2f", budget))")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Project Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
