import SwiftUI

struct TaskCalendarView: View {
    let tasks: [Task]
    @State private var selectedDate = Date()
    
    var tasksForSelectedDate: [Task] {
        tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return Calendar.current.isDate(dueDate, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        VStack {
            DatePicker(
                "Select Date",
                selection: ,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            .padding()
            
            if tasksForSelectedDate.isEmpty {
                Spacer()
                Text("No tasks due on this day")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(tasksForSelectedDate) { task in
                        NavigationLink(destination: TaskDetailView(task: task)) {
                            HStack {
                                Circle()
                                    .fill(priorityColor(task.priority))
                                    .frame(width: 10, height: 10)
                                
                                VStack(alignment: .leading) {
                                    Text(task.title)
                                        .fontWeight(.semibold)
                                    Text(task.status)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
    
    func priorityColor(_ priority: String) -> Color {
        switch priority.lowercased() {
        case "high": return .red
        case "medium": return .orange
        default: return .green
        }
    }
}
