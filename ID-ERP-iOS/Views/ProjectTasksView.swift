import SwiftUI

struct ProjectTasksView: View {
    let projectId: String
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State private var selectedView = 0 // 0: List, 1: Board, 2: Calendar
    
    var projectTasks: [Task] {
        firestoreManager.tasks.filter { .projectId == projectId }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("View", selection: ) {
                Image(systemName: "list.bullet").tag(0)
                Image(systemName: "square.grid.3x1.below.line.grid.1x2").tag(1) // Kanban icon approximation
                Image(systemName: "calendar").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()
            .background(Color(.systemBackground))
            
            TabView(selection: ) {
                TaskListView(tasks: projectTasks)
                    .tag(0)
                
                KanbanView(projectId: projectId) // Reusing existing KanbanView logic
                    .tag(1)
                
                TaskCalendarView(tasks: projectTasks)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationTitle("Project Tasks")
        .navigationBarTitleDisplayMode(.inline)
    }
}
