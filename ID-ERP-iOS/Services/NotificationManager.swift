import Foundation
import Firebase
import FirebaseMessaging
import UserNotifications

class NotificationManager: NSObject, ObservableObject, MessagingDelegate {
    static let shared = NotificationManager()
    
    @Published var notifications: [LocalNotification] = []
    @Published var unreadCount = 0
    @Published var fcmToken: String?
    
    override private init() {
        super.init()
        setupMessaging()
    }
    
    // MARK: - Setup
    private func setupMessaging() {
        Messaging.messaging().delegate = self
    }
    
    // MARK: - FCM Token
    func getFCMToken() {
        Messaging.messaging().token { [weak self] token, error in
            if let error = error {
                Logger.error("Error getting FCM token: \(error.localizedDescription)")
            } else if let token = token {
                DispatchQueue.main.async {
                    self?.fcmToken = token
                    Logger.debug("FCM Token retrieved")
                    self?.saveFCMToken(token)
                }
            }
        }
    }
    
    // MARK: - MessagingDelegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            DispatchQueue.main.async {
                self.fcmToken = token
                print("FCM Token updated: \(token)")
                self.saveFCMToken(token)
            }
        }
    }
    
    // MARK: - Save FCM Token to Firestore
    private func saveFCMToken(_ token: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).updateData([
            "fcm_token": token,
            "updated_at": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error saving FCM token: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Local Notifications
    func addNotification(_ notification: LocalNotification) {
        DispatchQueue.main.async {
            self.notifications.insert(notification, at: 0)
            self.unreadCount += 1
        }
    }
    
    func markAsRead(notification: LocalNotification) {
        DispatchQueue.main.async {
            if let index = self.notifications.firstIndex(of: notification) {
                var updatedNotification = self.notifications[index]
                updatedNotification.isRead = true
                self.notifications[index] = updatedNotification
                
                if !notification.isRead {
                    self.unreadCount = max(0, self.unreadCount - 1)
                }
            }
        }
    }
    
    func clearNotifications() {
        DispatchQueue.main.async {
            self.notifications.removeAll()
            self.unreadCount = 0
        }
    }
}

struct LocalNotification: Identifiable, Equatable {
    let id: String
    let title: String
    let message: String
    let timestamp: Date
    var isRead: Bool
    let type: NotificationType
    
    enum NotificationType: String {
        case projectUpdate = "project_update"
        case taskAssigned = "task_assigned"
        case taskCompleted = "task_completed"
        case messageReceived = "message_received"
        case systemAlert = "system_alert"
    }
}
