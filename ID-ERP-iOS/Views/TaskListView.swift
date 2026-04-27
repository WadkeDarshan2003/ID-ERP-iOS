import SwiftUI

struct TaskListView: View {
    let tasks: [Task]
    
    var body: some View {
        List {
            ForEach(tasks) { task in
                NavigationLink(destination: TaskDetailView(task: task)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 8) {
                            Label(task.status, systemImage: "circle.fill")
                                .font(.caption)
                                .foregroundColor(statusColor(task.status))
                            
                            Label(task.priority, systemImage: "exclamationmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(priorityColor(task.priority))
                            
                            if let dueDate = task.dueDate {
                                Label(dueDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func statusColor(_ status: String) -> Color {
        switch status {
        case "Done": return .green
        case "In Progress": return .blue
        default: return .gray
        }
    }
    
    func priorityColor(_ priority: String) -> Color {
        switch priority.lowercased() {
        case "high": return .red
        case "medium": return .orange
        default: return .green
        }
    }
}
