import SwiftUI

struct FinancialsView: View {
    let projectId: String
    @StateObject private var financialManager = FinancialManager.shared
    
    var body: some View {
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
