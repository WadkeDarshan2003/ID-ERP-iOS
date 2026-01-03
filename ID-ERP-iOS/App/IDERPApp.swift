import SwiftUI
import Firebase

@main
struct IDERPApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthenticationManager.shared)
                .environmentObject(FirestoreManager.shared)
                .environmentObject(NotificationManager.shared)
        }
    }
}
