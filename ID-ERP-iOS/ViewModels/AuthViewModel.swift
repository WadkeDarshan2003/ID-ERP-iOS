import Foundation

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var role = "user"
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showAlert = false
    
    private let authManager = AuthenticationManager.shared
    
    func login() {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        guard email.contains("@") else {
            errorMessage = "Please enter a valid email"
            showAlert = true
            return
        }
        
        authManager.login(email: email, password: password)
    }
    
    func register() {
        guard !email.isEmpty && !password.isEmpty && !name.isEmpty else {
            errorMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        guard email.contains("@") else {
            errorMessage = "Please enter a valid email"
            showAlert = true
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            showAlert = true
            return
        }
        
        authManager.register(email: email, password: password, name: name, role: role)
    }
    
    func logout() {
        authManager.logout()
    }
    
    func resetPassword() {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email"
            showAlert = true
            return
        }
        
        authManager.resetPassword(email: email)
    }
}
