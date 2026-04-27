import SwiftUI

struct TaskDetailView: View {
    let task: Task
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(task.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(task.description)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(label: "Status", value: task.status)
                    DetailRow(label: "Priority", value: task.priority)
                    DetailRow(label: "Assignee", value: task.assignee)
                    
                    if let dueDate = task.dueDate {
                        DetailRow(label: "Due Date", value: dueDate.formatted(date: .abbreviated, time: .omitted))
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
