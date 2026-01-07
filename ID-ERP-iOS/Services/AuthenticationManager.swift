import Foundation
import Firebase
import FirebaseAuth

class AuthenticationManager: NSObject, ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    override private init() {
        super.init()
        setupAuthStateListener()
    }
    
    // MARK: - Authentication State
    private func setupAuthStateListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            DispatchQueue.main.async {
                if let firebaseUser = user {
                    self?.isAuthenticated = true
                    self?.fetchUserProfile(uid: firebaseUser.uid)
                } else {
                    self?.isAuthenticated = false
                    self?.currentUser = nil
                }
            }
        }
    }
    
    // MARK: - Login
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    Logger.error("Login error: \(error.localizedDescription)")
                } else if let user = authResult?.user {
                    self?.fetchUserProfile(uid: user.uid)
                }
            }
        }
    }
    
    // MARK: - Register
    func register(email: String, password: String, name: String, role: String = "user") {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    Logger.error("Registration error: \(error.localizedDescription)")
                } else if let user = authResult?.user {
                    // Save user profile to Firestore
                    self?.createUserProfile(uid: user.uid, email: email, name: name, role: role)
                }
            }
        }
    }
    
    // MARK: - Logout
    func logout() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            isAuthenticated = false
            errorMessage = nil
        } catch let error {
            errorMessage = error.localizedDescription
            Logger.error("Logout error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Password Reset
    func resetPassword(email: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.errorMessage = "Password reset email sent successfully"
                }
            }
        }
    }
    
    // MARK: - Check Authentication Status
    func checkAuthenticationStatus() {
        if let user = Auth.auth().currentUser {
            isAuthenticated = true
            fetchUserProfile(uid: user.uid)
        } else {
            isAuthenticated = false
        }
    }
    
    // MARK: - Firestore User Management
    private func fetchUserProfile(uid: String) {
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { [weak self] document, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    Logger.error("Error fetching user profile: \(error.localizedDescription)")
                } else if let document = document, document.exists {
                    do {
                        let user = try document.data(as: User.self)
                        self?.currentUser = user
                    } catch {
                        Logger.error("Error decoding user: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func createUserProfile(uid: String, email: String, name: String, role: String) {
        let db = Firestore.firestore()
        
        // Align with Android/Web: uses camelCase
        let userData: [String: Any] = [
            "id": uid,
            "email": email,
            "name": name,
            "role": role,
            "createdAt": Timestamp(date: Date()),
            "isActive": true
        ]
        
        db.collection("users").document(uid).setData(userData) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    Logger.error("Error creating user profile: \(error.localizedDescription)")
                } else {
                    self?.isAuthenticated = true
                }
            }
        }
    }
}
