import Foundation

struct FinancialRecord: Codable, Identifiable {
    let id: String
    let date: Date
    let description: String
    let amount: Double
    let type: TransactionType
    let status: TransactionStatus
    let category: String
    
    enum TransactionType: String, Codable {
        case income
        case expense
    }
    
    enum TransactionStatus: String, Codable {
        case paid
        case pending
        case overdue
    }
}
