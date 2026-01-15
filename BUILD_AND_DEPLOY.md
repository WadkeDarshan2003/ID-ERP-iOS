# iOS Build & Deployment Guide - v1.0.1

> **Status**: ✅ Ready for Build and Deployment  
> **Last Updated**: January 15, 2026  
> **Platform**: iOS 14.0+  
> **Xcode**: 14.0+

## 📋 Pre-Build Checklist

- [ ] Xcode 14.0 or later installed
- [ ] CocoaPods installed (`gem install cocoapods`)
- [ ] Apple Developer Account active
- [ ] Provisioning profiles created
- [ ] Firebase project configured
- [ ] GoogleService-Info.plist placed in `/Resources`
- [ ] All pod dependencies installed

---

## 🚀 Build Process

### Step 1: Setup Development Environment

```bash
# Install CocoaPods if needed
sudo gem install cocoapods

# Navigate to project
cd /path/to/ID-ERP-iOS

# Install dependencies
pod install --repo-update
```

### Step 2: Open Workspace

```bash
# Open in Xcode (IMPORTANT: Use .xcworkspace, NOT .xcodeproj)
open ID-ERP-iOS.xcworkspace
```

### Step 3: Configure Signing

1. Select `ID-ERP-iOS` project in Xcode
2. Go to **Targets** → Select target
3. Go to **Signing & Capabilities**
4. Select your **Team**
5. Update **Bundle Identifier** if needed (e.g., `com.yourcompany.iderp`)
6. Ensure provisioning profile is selected

### Step 4: Build for Development

```bash
# Build for simulator (from Xcode or terminal)
xcodebuild -workspace ID-ERP-iOS.xcworkspace \
  -scheme ID-ERP-iOS \
  -configuration Debug \
  -sdk iphonesimulator \
  -derivedDataPath build

# Or simply: Cmd + B in Xcode
```

### Step 5: Run on Simulator

```bash
# In Xcode: Cmd + R
# Or select simulator target and click Run button
```

---

## 📦 Build for Release (TestFlight & App Store)

### Build Settings

1. In Xcode:
   - Select **ID-ERP-iOS** project
   - Select **Build Settings**
   - Set **Code Signing Identity** = "Apple Distribution"
   - Set **Provisioning Profile** = "ID-ERP-iOS Distribution"

### Create Archive

```bash
xcodebuild -workspace ID-ERP-iOS.xcworkspace \
  -scheme ID-ERP-iOS \
  -configuration Release \
  -sdk iphoneos \
  -archivePath build/ID-ERP-iOS.xcarchive \
  archive
```

Or in Xcode:
1. Select `Generic iOS Device` as build target
2. Product → Archive
3. Wait for build to complete

### Upload to TestFlight

```bash
xcodebuild -exportArchive \
  -archivePath build/ID-ERP-iOS.xcarchive \
  -exportOptionsPlist exportOptions.plist \
  -exportPath build/
```

Then use **Xcode Organizer** or **Transporter app**:
1. Window → Organizer
2. Archives tab
3. Select archive → Distribute App
4. Choose TestFlight or App Store

---

## 🔧 Configuration Files

### GoogleService-Info.plist

**Location**: `ID-ERP-iOS/Resources/GoogleService-Info.plist`

1. Download from Firebase Console
2. Drag into Xcode (ensure "Copy items if needed" is checked)
3. Add to target membership: ✅ ID-ERP-iOS

### Bundle Identifier

**Default**: `com.iderp.ios`  
**Update in**: Xcode → Targets → General → Bundle Identifier

### Version & Build Number

In **Xcode** or **Info.plist**:
- **Version**: 1.0.1 (Customer-facing)
- **Build**: Increment for each TestFlight/App Store submission

---

## 🔑 Firebase Configuration

### Required Services

✅ **Authentication**
- Email/Password enabled
- Phone sign-in (optional)

✅ **Cloud Firestore**
- Database region: `asia-south1` (India)
- Collections: users, projects, tasks, documents

✅ **Cloud Storage**
- Bucket created and accessible

✅ **Cloud Messaging**
- APNs certificate configured
- Server key saved

### Security Rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    match /projects/{projectId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

## 📲 Device Deployment

### Prepare Real Device

1. Connect iPhone via USB
2. Trust the computer when prompted
3. In Xcode: Window → Devices and Simulators
4. Verify device appears and is trusted

### Deploy to Device

1. Select your device as build target (top-left dropdown)
2. Press Cmd + R (Run)
3. Grant permission when prompted
4. App installs and launches

### Debugging

```bash
# View device logs
xcrun simctl spawn booted log stream --predicate 'process == "ID-ERP-iOS"'

# Real device logs in Xcode: Window → Devices and Simulators
```

---

## 🧪 Testing Before Submission

### Functional Tests

- [ ] Login/Register flow
- [ ] Create/Edit/Delete projects
- [ ] Task management
- [ ] Financial records
- [ ] Document upload/download
- [ ] Notifications (push & local)
- [ ] Multi-tenant switching
- [ ] Offline mode (if implemented)

### Performance

- [ ] App launch time < 3 seconds
- [ ] Memory usage < 100MB
- [ ] No crashes during navigation
- [ ] Smooth scrolling/animations

### Compliance

- [ ] Privacy policy visible
- [ ] Terms of service available
- [ ] All permissions justified
- [ ] No hardcoded credentials

---

## 📤 App Store Submission

### Pre-Submission

1. **Screenshots**: Provide 5-6 per iPhone size category
2. **Preview Video**: Optional (15-30 seconds)
3. **Description**: Clear feature list
4. **Keywords**: SEO optimization
5. **Support URL**: Active support link
6. **Privacy Policy**: HTTPS link

### Submit to App Store

1. Xcode → Organizer → Archives
2. Distribute App → App Store Connect
3. Complete submission form in App Store Connect
4. Submit for review
5. Wait for review (1-3 days)
6. Release when approved

---

## 🔄 Version Management

### Current Version: 1.0.1

**Features**:
- Multi-tenant ERP system
- Firebase authentication & Firestore
- Project, task, and financial management
- Push notifications & email alerts
- Document upload to Cloud Storage
- Real-time data sync

### Next Updates

- v1.1.0: Enhanced offline sync
- v1.2.0: Advanced reporting
- v1.3.0: WhatsApp integration
- v2.0.0: Redesigned UI

---

## 🐛 Troubleshooting

### Pod Install Issues

```bash
pod install --repo-update
rm -rf Pods Podfile.lock
pod install
```

### Build Fails

```bash
# Clean build
xcodebuild clean
rm -rf build/
pod install

# Try again
xcodebuild -workspace ID-ERP-iOS.xcworkspace -scheme ID-ERP-iOS build
```

### Firebase Connection Issues

- Verify GoogleService-Info.plist is added to target
- Check Firebase project ID matches
- Ensure Firestore database is running

### Push Notifications Not Working

- APNs certificate configured in Firebase
- Device has notifications enabled
- FCM token is being saved to user document

---

## 📞 Support

For issues:
1. Check [README.md](README.md)
2. Review [Firebase docs](https://firebase.google.com/docs/ios)
3. Check Xcode build logs: Cmd + Shift + K, then Cmd + B
4. Review device console: Window → Device Console

---

**Ready to build! 🎉**
