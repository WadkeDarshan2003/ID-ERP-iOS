import SwiftUI

struct SidebarView: View {
    @Binding var isShowing: Bool
    @Binding var selectedTab: DashboardView.Tab
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        ZStack {
            // Dimmed background
            if isShowing {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { isShowing = false }
                    }
            }
            
            // Menu content
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading) {
                        if let user = authManager.currentUser {
                            Text(user.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(user.email)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 50)
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Menu Items
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            MenuRow(icon: "house", title: "Dashboard", tab: .home, selectedTab: , isShowing: )
                            MenuRow(icon: "folder", title: "Projects", tab: .projects, selectedTab: , isShowing: )
                            MenuRow(icon: "checkmark.circle", title: "Tasks", tab: .tasks, selectedTab: , isShowing: )
                            MenuRow(icon: "person.2", title: "People", tab: .people, selectedTab: , isShowing: )
                            MenuRow(icon: "bell", title: "Notifications", tab: .notifications, selectedTab: , isShowing: )
                            MenuRow(icon: "gear", title: "Settings", tab: .settings, selectedTab: , isShowing: )
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    // Logout
                    Button(action: {
                        authManager.logout()
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.square")
                            Text("Logout")
                        }
                        .foregroundColor(.red)
                        .padding()
                    }
                }
                .frame(width: 280)
                .background(Color(.systemBackground))
                .offset(x: isShowing ? 0 : -280)
                
                Spacer()
            }
        }
    }
}

struct MenuRow: View {
    let icon: String
    let title: String
    let tab: DashboardView.Tab
    @Binding var selectedTab: DashboardView.Tab
    @Binding var isShowing: Bool
    
    var body: some View {
        Button(action: {
            selectedTab = tab
            withAnimation { isShowing = false }
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .frame(width: 24)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            .padding()
            .foregroundColor(selectedTab == tab ? .blue : .primary)
            .background(selectedTab == tab ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(10)
        }
    }
}
