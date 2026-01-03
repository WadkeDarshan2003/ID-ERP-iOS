import SwiftUI

struct KanbanView: View {
    let projectId: String
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var projectTasks: [Task] {
        firestoreManager.tasks.filter { .projectId == projectId }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 20) {
                KanbanColumn(title: "To Do", tasks: projectTasks.filter { .status == "To Do" })
                KanbanColumn(title: "In Progress", tasks: projectTasks.filter { .status == "In Progress" })
                KanbanColumn(title: "Done", tasks: projectTasks.filter { .status == "Done" })
            }
            .padding()
        }
        .navigationTitle("Kanban Board")
    }
}

struct KanbanColumn: View {
    let title: String
    let tasks: [Task]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 8)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(tasks) { task in
                        KanbanCard(task: task)
                    }
                }
            }
        }
        .frame(width: 250)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct KanbanCard: View {
    let task: Task
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.title)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            HStack {
                if let dueDate = task.dueDate {
                    Text(dueDate.formatted(date: .numeric, time: .omitted))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Circle()
                    .fill(priorityColor(task.priority))
                    .frame(width: 8, height: 8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
    }
    
    func priorityColor(_ priority: String) -> Color {
        switch priority.lowercased() {
        case "high": return .red
        case "medium": return .orange
        default: return .green
        }
    }
}
