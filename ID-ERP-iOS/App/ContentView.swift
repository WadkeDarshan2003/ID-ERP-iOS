import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showLoginView = true
    
    var body: some View {
        ZStack {
            if authManager.isAuthenticated {
                DashboardView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            // Check if user is already authenticated
            authManager.checkAuthenticationStatus()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationManager.shared)
}
