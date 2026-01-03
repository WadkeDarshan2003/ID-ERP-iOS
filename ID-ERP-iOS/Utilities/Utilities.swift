import Foundation

// MARK: - Validation Utilities
class ValidationUtils {
    
    /// Validate email format
    static func isValidEmail(_ email: String) -> Bool {
        return email.isValidEmail
    }
    
    /// Validate password strength
    static func isValidPassword(_ password: String) -> Bool {
        return password.isStrongPassword
    }
    
    /// Validate name (not empty, reasonable length)
    static func isValidName(_ name: String) -> Bool {
        let trimmed = name.trimmed
        return !trimmed.isEmpty && trimmed.count >= 2 && trimmed.count <= 100
    }
    
    /// Validate phone number (basic)
    static func isValidPhoneNumber(_ phone: String) -> Bool {
        let digits = phone.filter { $0.isNumber }
        return digits.count >= 10 && digits.count <= 15
    }
    
    /// Validate URL
    static func isValidURL(_ urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}

// MARK: - Formatting Utilities
class FormattingUtils {
    
    /// Format bytes to human readable size
    static func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB]
        formatter.countStyle = .binary
        return formatter.string(fromByteCount: bytes)
    }
    
    /// Format number to string with thousand separators
    static func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    /// Format percentage
    static func formatPercentage(_ value: Double, decimals: Int = 2) -> String {
        return String(format: "%.\(decimals)f%%", value * 100)
    }
    
    /// Format date to readable string
    static func formatDate(_ date: Date, format: String = "MMM dd, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    /// Format time to readable string
    static func formatTime(_ date: Date, format: String = "HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

// MARK: - String Utilities
class StringUtils {
    
    /// Capitalize first letter
    static func capitalize(_ string: String) -> String {
        return string.prefix(1).uppercased() + string.dropFirst()
    }
    
    /// Truncate string to length
    static func truncate(_ string: String, to length: Int) -> String {
        if string.count > length {
            return String(string.prefix(length)) + "..."
        }
        return string
    }
    
    /// Generate random string
    static func generateRandomString(length: Int = 10) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    /// Remove special characters
    static func removeSpecialCharacters(_ string: String) -> String {
        return string.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }
}

// MARK: - Date Utilities
class DateUtils {
    
    /// Get current timestamp in milliseconds
    static var currentTimestamp: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    /// Convert timestamp to Date
    static func dateFromTimestamp(_ timestamp: Int64) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
    }
    
    /// Get date after days
    static func dateAfterDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
    }
    
    /// Get date before days
    static func dateBeforeDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
    }
    
    /// Get start of day
    static func startOfDay(_ date: Date = Date()) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
    
    /// Get end of day
    static func endOfDay(_ date: Date = Date()) -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay(date)) ?? Date()
    }
}

// MARK: - Color Utilities
class ColorUtils {
    
    /// Convert hex string to UIColor
    static func hexToColor(_ hex: String) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// Convert UIColor to hex string
    static func colorToHex(_ color: UIColor) -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb = Int(red * 255) << 16 | Int(green * 255) << 8 | Int(blue * 255)
        return String(format: "#%06x", rgb)
    }
}

// MARK: - Device Utilities
class DeviceUtils {
    
    /// Get device model
    static var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
    
    /// Get OS version
    static var osVersion: String {
        return UIDevice.current.systemVersion
    }
    
    /// Check if running on simulator
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    /// Get app version
    static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    /// Get app build number
    static var buildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
}
