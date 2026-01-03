import Foundation

// MARK: - String Extensions
extension String {
    /// Check if email is valid
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    /// Check if password is strong
    var isStrongPassword: Bool {
        return self.count >= 6 && self.count <= 128
    }
    
    /// Trim whitespace
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    /// Check if empty or whitespace only
    var isEmpty: Bool {
        return self.trimmed.isEmpty
    }
}

// MARK: - Date Extensions
extension Date {
    /// Format date to string
    func formatted(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /// Get relative time string (e.g., "2 hours ago")
    var timeAgoDisplay: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    /// Check if date is today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Check if date is tomorrow
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// Check if date is yesterday
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
}

// MARK: - Double Extensions
extension Double {
    /// Format as currency
    func asCurrency(currency: String = "USD") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
    
    /// Round to decimal places
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

// MARK: - Array Extensions
extension Array {
    /// Safe subscript to prevent index out of bounds
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Dictionary Extensions
extension Dictionary {
    /// Check if dictionary is empty or nil
    var isEmptyOrNil: Bool {
        return self.isEmpty
    }
}

// MARK: - Optional Extensions
extension Optional {
    /// Check if optional is nil
    var isNil: Bool {
        return self == nil
    }
    
    /// Check if optional has value
    var hasValue: Bool {
        return self != nil
    }
}
