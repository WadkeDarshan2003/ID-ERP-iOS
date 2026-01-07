import Foundation

struct FinancialRecord: Codable, Identifiable {
    let id: String
    let date: Date
    var timestamp: String? // ISO timestamp for sorting
    let description: String
    let amount: Double
    let type: TransactionType
    var status: TransactionStatus
    let category: String
    
    // Vendor and Payment Tracking
    var vendorId: String?
    var vendorName: String?
    var paidBy: String? // client, vendor, designer, admin, other
    var paidByOther: String?
    var paidByRole: String?
    var receivedBy: String?
    var receivedByName: String?
    var receivedByRole: String?
    var paidTo: String?
    
    // Approvals
    var adminApproved: Bool?
    var clientApproved: Bool?
    
    // Additional Budget and Payment Flags
    var isAdditionalBudget: Bool?
    var clientApprovalForAdditionalBudget: String? // "pending", "approved", "rejected"
    var adminApprovalForAdditionalBudget: String?
    var isClientPayment: Bool?
    var clientApprovalForPayment: String?
    var adminApprovalForPayment: String?
    var paymentMode: String? // "cash", "upi", "bank_transfer", "cheque", "credit_card", "other"
    
    enum TransactionType: String, Codable {
        case income
        case expense
        case designerCharge = "designer-charge"
    }
    
    enum TransactionStatus: String, Codable {
        case paid
        case pending
        case overdue
        case hold
    }
}
