import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        Form {
            Section("Appearance") {
                Toggle("Dark Mode", isOn: )
            }
            
            Section("Notifications") {
                Toggle("Enable Notifications", isOn: )
            }
            
            Section("Account") {
                if let user = authManager.currentUser {
                    NavigationLink(destination: Text("Edit Profile")) {
                        Text("Edit Profile")
                    }
                    
                    NavigationLink(destination: Text("Change Password")) {
                        Text("Change Password")
                    }
                }
            }
            
            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.gray)
                }
                
                Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
            }
            
            Section {
                Button(role: .destructive, action: {
                    authManager.logout()
                }) {
                    Text("Logout")
                }
            }
        }
        .navigationTitle("Settings")
    }
}
