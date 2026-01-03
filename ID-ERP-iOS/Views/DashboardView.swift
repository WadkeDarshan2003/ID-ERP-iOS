import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var firestoreManager: FirestoreManager
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: ) {
            // Home Tab
            HomeTabView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            // Projects Tab
            ProjectsTabView()
                .tabItem {
                    Label("Projects", systemImage: "folder.fill")
                }
                .tag(1)
            
            // Tasks Tab
            TasksTabView()
                .tabItem {
                    Label("Tasks", systemImage: "checkmark.circle.fill")
                }
                .tag(2)
            
            // Notifications Tab
            NotificationsTabView()
                .tabItem {
                    Label("Notifications", systemImage: "bell.fill")
                        .badge(notificationManager.unreadCount > 0 ? notificationManager.unreadCount : nil)
                }
                .tag(3)
            
            // Profile Tab
            ProfileTabView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(4)
        }
        .onAppear {
            firestoreManager.fetchProjects()
            firestoreManager.fetchTasks()
            notificationManager.getFCMToken()
        }
    }
}

// MARK: - Tab Views
struct HomeTabView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Welcome Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome back!")
                            .font(.headline)
                        
                        if let user = authManager.currentUser {
                            Text(user.name)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Quick Stats
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            StatCard(
                                title: "Projects",
                                value: String(firestoreManager.projects.count),
                                icon: "folder.fill",
                                color: .blue
                            )
                            
                            StatCard(
                                title: "Tasks",
                                value: String(firestoreManager.tasks.count),
                                icon: "checkmark.circle.fill",
                                color: .green
                            )
                        }
                        
                        HStack(spacing: 12) {
                            StatCard(
                                title: "Team",
                                value: String(firestoreManager.users.count),
                                icon: "people.fill",
                                color: .purple
                            )
                            
                            StatCard(
                                title: "Active",
                                value: "85%",
                                icon: "chart.bar.fill",
                                color: .orange
                            )
                        }
                    }
                    
                    Divider()
                    
                    // Recent Projects
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Projects")
                            .font(.headline)
                        
                        if firestoreManager.projects.isEmpty {
                            Text("No projects yet")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        } else {
                            ForEach(firestoreManager.projects.prefix(3)) { project in
                                ProjectRow(project: project)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct ProjectsTabView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State private var showNewProjectSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(firestoreManager.projects) { project in
                    NavigationLink(destination: ProjectDetailView(project: project)) {
                        ProjectRow(project: project)
                    }
                }
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showNewProjectSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: ) {
                NewProjectSheet()
            }
        }
    }
}

struct TasksTabView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(firestoreManager.tasks) { task in
                    NavigationLink(destination: TaskDetailView(task: task)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title)
                                .fontWeight(.semibold)
                            
                            HStack(spacing: 8) {
                                Label(task.status, systemImage: "circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                
                                Label(task.priority, systemImage: "exclamationmark.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tasks")
        }
    }
}

struct NotificationsTabView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    
    var body: some View {
        NavigationStack {
            List {
                if notificationManager.notifications.isEmpty {
                    Text("No notifications")
                        .foregroundColor(.gray)
                } else {
                    ForEach(notificationManager.notifications) { notification in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(notification.title)
                                    .fontWeight(.semibold)
                                
                                if !notification.isRead {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 8, height: 8)
                                }
                            }
                            
                            Text(notification.message)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(notification.timestamp.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            notificationManager.markAsRead(notification: notification)
                        }
                    }
                }
            }
            .navigationTitle("Notifications")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !notificationManager.notifications.isEmpty {
                        Button(action: {
                            notificationManager.clearNotifications()
                        }) {
                            Text("Clear")
                        }
                    }
                }
            }
        }
    }
}

struct ProfileTabView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationStack {
            List {
                if let user = authManager.currentUser {
                    Section("Profile Information") {
                        LabeledContent("Name", value: user.name)
                        LabeledContent("Email", value: user.email)
                        LabeledContent("Role", value: user.role)
                        
                        if let department = user.department {
                            LabeledContent("Department", value: department)
                        }
                    }
                }
                
                Section {
                    Button(role: .destructive, action: {
                        authManager.logout()
                    }) {
                        Label("Logout", systemImage: "arrow.right.circle.fill")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

// MARK: - Component Views
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ProjectRow: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(project.name)
                .fontWeight(.semibold)
            
            Text(project.description)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            HStack(spacing: 8) {
                Label(project.status, systemImage: "circle.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text(project.startDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}
