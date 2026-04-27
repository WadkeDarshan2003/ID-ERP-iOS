import SwiftUI

struct FinancialsView: View {
    let projectId: String
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var financialManager = FinancialManager.shared
    
    var body: some View {
        // Role-based access: Only Admin, Designer can view
        if let userRole = authManager.currentUser?.role,
           (userRole == "Admin" || userRole == "Designer") {
            VStack {
                // Summary Card
                HStack(spacing: 20) {
                    SummaryCard(title: "Income", amount: calculateTotal(type: .income), color: .green)
                    SummaryCard(title: "Expenses", amount: calculateTotal(type: .expense), color: .red)
                }
                .padding()
                
                List {
                    ForEach(financialManager.transactions) { transaction in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(transaction.description)
                                    .font(.headline)
                                Text(transaction.category)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text(formatAmount(transaction.amount))
                                .foregroundColor(transaction.type == .income ? .green : .red)
                                .fontWeight(.bold)
                        }
                    }
                }
            }
            .navigationTitle("Financials")
            .onAppear {
                financialManager.fetchFinancials(for: projectId)
            }
        } else {
            VStack(spacing: 20) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.red)
                
                Text("Access Denied")
                    .font(.headline)
                
                Text("You don't have permission to view financial data.")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationTitle("Financials")
        }
    }
    
    private func calculateTotal(type: FinancialRecord.TransactionType) -> Double {
        financialManager.transactions
            .filter { $0.type == type }
            .reduce(0) { $0 + $1.amount }
    }
    
    private func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: amount)) ?? ".00"
    }
}
