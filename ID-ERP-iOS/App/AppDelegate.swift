import UIKit
import Firebase
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Request user notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
        
        // Set notification delegate
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    // Handle remote notifications
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // Handle notification payload
        handleNotificationPayload(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    private func handleNotificationPayload(_ userInfo: [AnyHashable: Any]) {
        let aps = userInfo["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: Any]
        
        let title = alert?["title"] as? String ?? userInfo["title"] as? String ?? "New Notification"
        let body = alert?["body"] as? String ?? userInfo["body"] as? String ?? ""
        
        let notification = LocalNotification(
            id: UUID().uuidString,
            title: title,
            message: body,
            timestamp: Date(),
            isRead: false,
            type: userInfo["type"] as? String ?? "info",
            projectId: userInfo["projectId"] as? String,
            projectName: userInfo["projectName"] as? String,
            targetTab: userInfo["targetTab"] as? String,
            taskId: userInfo["taskId"] as? String,
            meetingId: userInfo["meetingId"] as? String,
            deepLinkPath: userInfo["deepLinkPath"] as? String
        )
        
        NotificationManager.shared.addNotification(notification)
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Handle notification when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        
        if let title = notification.request.content.title as String? {
            print("Notification received: \(title)")
        }
        
        // Show notification even when app is in foreground
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    // Handle notification tap
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        let aps = userInfo["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: Any]
        
        let title = alert?["title"] as? String ?? userInfo["title"] as? String ?? "New Notification"
        let body = alert?["body"] as? String ?? userInfo["body"] as? String ?? ""
        
        let notification = LocalNotification(
            id: UUID().uuidString,
            title: title,
            message: body,
            timestamp: Date(),
            isRead: true, // Mark as read if they tapped it
            type: userInfo["type"] as? String ?? "info",
            projectId: userInfo["projectId"] as? String,
            projectName: userInfo["projectName"] as? String,
            targetTab: userInfo["targetTab"] as? String,
            taskId: userInfo["taskId"] as? String,
            meetingId: userInfo["meetingId"] as? String,
            deepLinkPath: userInfo["deepLinkPath"] as? String
        )
        
        DispatchQueue.main.async {
            NotificationManager.shared.selectedNotification = notification
        }
        
        completionHandler()
    }
}
