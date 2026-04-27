# ID ERP iOS Application

Enterprise Resource Planning (ERP) iOS Application with Firebase integration. Built with SwiftUI and MVVM architecture.

## 📋 Prerequisites

- **Xcode** 14.0 or later
- **iOS** 14.0 or later as deployment target
- **CocoaPods** 1.11+
- **Firebase Account** with project created
- **Mac with Apple Silicon or Intel processor**

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/WadkeDarshan2003/ID-ERP-iOS.git
cd ID-ERP-iOS
```

### 2. Install Dependencies

#### Option A: Using CocoaPods (Recommended)

```bash
# Install CocoaPods if not already installed
sudo gem install cocoapods

# Install pod dependencies
pod install

# Open the workspace (NOT the .xcodeproj file)
open ID-ERP-iOS.xcworkspace
```

#### Option B: Using Swift Package Manager

The project can also be used with SPM, but CocoaPods is recommended for Firebase.

### 3. Firebase Setup

#### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "ID-ERP-iOS"
3. Register your iOS app with bundle ID `com.iderp.ios`
4. Download `GoogleService-Info.plist`

#### Step 2: Configure GoogleService-Info.plist
1. Download the `GoogleService-Info.plist` file from Firebase Console
2. Place it in `ID-ERP-iOS/Resources/` directory
3. In Xcode:
   - Select the file
   - Go to File Inspector (Right panel)
   - Under "Target Membership", ensure it's added to the app target

#### Step 3: Setup Firebase Services

**Authentication:**
- Go to Firebase Console → Authentication
- Enable Sign-in method: Email/Password
- (Optional) Enable Google Sign-in

**Firestore Database:**
- Create a Cloud Firestore database in **Test Mode**
- Create collections:
  - `users` - Store user profiles
  - `projects` - Store project data
  - `tasks` - Store task data

**Cloud Storage:**
- Create a Cloud Storage bucket
- Set security rules:

```rules
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth.uid == userId;
    }
    match /projects/{projectId}/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**Cloud Messaging:**
- Enable Cloud Messaging in Firebase Console
- Configure APNs certificate (required for push notifications on real devices)

#### Step 4: Setup Firestore Rules

Create Firestore security rules:

```rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    match /projects/{projectId} {
      allow read, write: if request.auth != null;
    }
    
    match /tasks/{taskId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 📁 Project Structure

```
ID-ERP-iOS/
├── ID-ERP-iOS/
│   ├── App/
│   │   ├── IDERPApp.swift           # Main app entry point
│   │   ├── AppDelegate.swift        # App lifecycle & notifications
│   │   └── ContentView.swift        # Root view
│   ├── Models/
│   │   └── User.swift               # Data models
│   ├── Services/
│   │   ├── AuthenticationManager.swift  # Firebase Auth
│   │   ├── FirestoreManager.swift       # Firestore operations
│   │   └── NotificationManager.swift    # Push notifications
│   ├── ViewModels/
│   │   └── AuthViewModel.swift      # Authentication logic
│   ├── Views/
│   │   ├── LoginView.swift          # Login screen
│   │   ├── RegisterView.swift       # Registration screen
│   │   └── DashboardView.swift      # Main dashboard & tabs
│   ├── Utilities/
│   │   └── (utility functions)
│   └── Resources/
│       ├── GoogleService-Info.plist # Firebase config
│       └── Info.plist               # App configuration
├── Podfile                          # CocoaPods dependencies
└── README.md                        # This file
```

## 🏗️ Architecture

### MVVM (Model-View-ViewModel)

- **Models**: `User`, `Project`, `Task` - Data structures
- **Views**: SwiftUI views for UI
- **ViewModels**: Business logic and state management
- **Services**: Firebase integration layer

### Key Services

#### AuthenticationManager
```swift
// Login
AuthenticationManager.shared.login(email: "user@example.com", password: "password")

// Register
AuthenticationManager.shared.register(email: "user@example.com", password: "password", name: "John Doe")

// Logout
AuthenticationManager.shared.logout()

// Check auth status
AuthenticationManager.shared.checkAuthenticationStatus()
```

#### FirestoreManager
```swift
// Fetch projects
FirestoreManager.shared.fetchProjects()

// Create project
let project = Project(id: UUID().uuidString, name: "New Project", ...)
FirestoreManager.shared.createProject(project)

// Update/Delete
FirestoreManager.shared.updateProject(project)
FirestoreManager.shared.deleteProject(id: projectId)
```

#### NotificationManager
```swift
// Get FCM Token
NotificationManager.shared.getFCMToken()

// Add local notification
let notification = LocalNotification(...)
NotificationManager.shared.addNotification(notification)

// Mark as read
NotificationManager.shared.markAsRead(notification: notification)
```

## 📱 Features

- ✅ Email/Password Authentication
- ✅ Firestore Database Integration
- ✅ Cloud Storage Support
- ✅ Push Notifications (FCM)
- ✅ Project Management
- ✅ Task Management
- ✅ User Management
- ✅ Real-time Updates
- ✅ Dark Mode Support
- ✅ MVVM Architecture

## 🔐 Security

### Best Practices Implemented

1. **Authentication**
   - Firebase Authentication with email/password
   - Secure token management
   - Automatic session handling

2. **Data Protection**
   - Firestore security rules
   - User-specific data access
   - Encrypted storage for sensitive data (use Keychain)

3. **Network Security**
   - HTTPS only communication
   - Certificate pinning (recommended for production)
   - Secure Firebase rules

4. **API Keys**
   - Never commit `GoogleService-Info.plist` with production keys
   - Use environment-specific configurations
   - Rotate keys regularly

## 📝 Environment Configuration

Create an `Info.plist` for different environments:

**Development (Info-Dev.plist):**
- Firebase dev project
- Staging Firestore database

**Production (Info-Prod.plist):**
- Firebase production project
- Production Firestore database

## 🧪 Testing

### Unit Tests

```swift
import XCTest
@testable import ID_ERP_iOS

class AuthenticationManagerTests: XCTestCase {
    func testLogin() {
        let authManager = AuthenticationManager.shared
        authManager.login(email: "test@example.com", password: "password")
        XCTAssertTrue(authManager.isAuthenticated)
    }
}
```

### Running Tests

```bash
# In Xcode: Cmd + U
# Or via terminal:
xcodebuild test -workspace ID-ERP-iOS.xcworkspace -scheme ID-ERP-iOS
```

## 🚀 Building & Deployment

### Development Build

```bash
# Open workspace
open ID-ERP-iOS.xcworkspace

# Select target scheme: ID-ERP-iOS
# Select destination: Any iOS Simulator or connected device
# Build: Cmd + B
# Run: Cmd + R
```

### Release Build

```bash
# Archive
xcodebuild archive -workspace ID-ERP-iOS.xcworkspace \
  -scheme ID-ERP-iOS \
  -archivePath build/ID-ERP-iOS.xcarchive

# Export for App Store
xcodebuild -exportArchive \
  -archivePath build/ID-ERP-iOS.xcarchive \
  -exportOptionsPlist exportOptions.plist \
  -exportPath build/
```

### App Store Submission

1. Update version in `Info.plist`
2. Update build number
3. Archive the app
4. Export for App Store
5. Upload to App Store Connect
6. Fill in metadata and submit for review

## 📦 Dependencies

| Pod | Version | Purpose |
|-----|---------|---------|
| Firebase/Core | Latest | Firebase core functionality |
| Firebase/Auth | Latest | Authentication |
| Firebase/Firestore | Latest | Database |
| Firebase/Storage | Latest | Cloud Storage |
| Firebase/Messaging | Latest | Push Notifications |
| Alamofire | ~5.7 | Networking |
| Kingfisher | ~7.0 | Image caching |
| KeychainSwift | Latest | Secure storage |
| SwiftyJSON | Latest | JSON parsing |

## 🔄 API Integration

### Base URL Configuration

```swift
let baseURL = "https://your-api.com/api"

// Use Alamofire for API calls
AF.request(baseURL + "/endpoint").responseJSON { response in
    // Handle response
}
```

### Authentication Headers

```swift
let headers: HTTPHeaders = [
    "Authorization": "Bearer \(authToken)",
    "Content-Type": "application/json"
]
```

## 🐛 Debugging

### Enable Firebase Logging

```swift
import Firebase

// In AppDelegate
FirebaseApp.configure()

// Enable debug logging
FirebaseConfiguration.shared.setLoggingLevel(.min)
```

### Common Issues

**Issue**: Pod installation fails
```bash
# Solution:
rm -rf Pods
rm Podfile.lock
pod install
```

**Issue**: GoogleService-Info.plist not found
- Ensure file is added to Xcode target
- Check file location: `ID-ERP-iOS/Resources/`

**Issue**: Firebase authentication fails
- Verify bundle ID matches Firebase project
- Check GoogleService-Info.plist is properly configured
- Ensure Firebase Authentication is enabled

## 📚 Documentation Links

- [Firebase iOS Documentation](https://firebase.google.com/docs/ios/setup)
- [SwiftUI Documentation](https://developer.apple.com/tutorials/SwiftUI)
- [Xcode Help](https://help.apple.com/xcode/)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)

## 🤝 Contributing

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Commit changes: `git commit -am 'Add feature'`
3. Push to branch: `git push origin feature/your-feature`
4. Open a pull request

## 📄 License

MIT License - see LICENSE file for details

## 👤 Author

Darshan Wadke
- GitHub: [@WadkeDarshan2003](https://github.com/WadkeDarshan2003)

## 🆘 Support

For issues and questions:
1. Check existing GitHub issues
2. Create a new issue with detailed description
3. Include error logs and reproduction steps

---

**Last Updated**: January 3, 2026
**Version**: 1.0.0
**Status**: Ready for Xcode development
