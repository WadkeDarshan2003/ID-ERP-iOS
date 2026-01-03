import Foundation

// MARK: - Custom Error Types
enum AppError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case authenticationFailed
    case authorizationFailed
    case notFound
    case serverError(Int)
    case unknownError
    case customError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .authenticationFailed:
            return "Authentication failed"
        case .authorizationFailed:
            return "You don't have permission to perform this action"
        case .notFound:
            return "Resource not found"
        case .serverError(let code):
            return "Server error: \(code)"
        case .unknownError:
            return "An unknown error occurred"
        case .customError(let message):
            return message
        }
    }
}

// MARK: - Result Type
typealias ApiResult<T> = Result<T, AppError>
