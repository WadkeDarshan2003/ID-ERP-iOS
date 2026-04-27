import Foundation

/// Manager to handle sensitive keys and configuration from Secrets.plist
class SecretManager {
    static let shared = SecretManager()
    
    private var secrets: NSDictionary?
    
    private init() {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") {
            secrets = NSDictionary(contentsOfFile: path)
        }
    }
    
    func getSecret(forKey key: String) -> String {
        return secrets?.object(forKey: key) as? String ?? ""
    }
    
    // Convenience properties
    var firebaseProjectID: String {
        return getSecret(forKey: "FIREBASE_PROJECT_ID")
    }
    
    var firebaseRegion: String {
        return getSecret(forKey: "FIREBASE_REGION")
    }
    
    var firebaseAPIKey: String {
        return getSecret(forKey: "FIREBASE_API_KEY")
    }
    
    var firebaseAppID: String {
        return getSecret(forKey: "FIREBASE_APP_ID")
    }
}
