import SwiftUI

struct PeopleView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State private var selectedTab = 0
    
    var designers: [User] {
        firestoreManager.users.filter { .role == "designer" || .role == "admin" }
    }
    
    var clients: [User] {
        firestoreManager.users.filter { .role == "client" }
    }
    
    var vendors: [User] {
        firestoreManager.users.filter { .role == "vendor" }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("Category", selection: ) {
                Text("Team").tag(0)
                Text("Clients").tag(1)
                Text("Vendors").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()
            .background(Color(.systemBackground))
            
            TabView(selection: ) {
                UserListView(users: designers, title: "Team Members")
                    .tag(0)
                
                UserListView(users: clients, title: "Clients")
                    .tag(1)
                
                UserListView(users: vendors, title: "Vendors")
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationTitle("People")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserListView: View {
    let users: [User]
    let title: String
    
    var body: some View {
        List {
            if users.isEmpty {
                Text("No \(title.lowercased()) found")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(users) { user in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Text(user.name.prefix(1).uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name)
                                .fontWeight(.semibold)
                            
                            Text(user.email)
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            if let dept = user.department {
                                Text(dept)
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(4)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}
