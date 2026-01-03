import Foundation

/// Logger utility for debugging
class Logger {
    
    enum LogLevel {
        case debug
        case info
        case warning
        case error
        
        var prefix: String {
            switch self {
            case .debug:
                return "🔍 DEBUG"
            case .info:
                return "ℹ️ INFO"
            case .warning:
                return "⚠️ WARNING"
            case .error:
                return "❌ ERROR"
            }
        }
    }
    
    static func log(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let timestamp = DateFormatter.localizedString(
            from: Date(),
            dateStyle: .none,
            timeStyle: .medium
        )
        print("[\(timestamp)] \(level.prefix) [\(fileName):\(line)] \(function) - \(message)")
        #endif
    }
    
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }
    
    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }
    
    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }
    
    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }
}
