import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FinancialManager: ObservableObject {
    static let shared = FinancialManager()
    private let db = Firestore.firestore()
    
    @Published var transactions: [FinancialRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchFinancials(for projectId: String) {
        isLoading = true
        // Assuming financials are stored in a subcollection 'financials' under the project
        // If they are an array in the project document, they are already fetched with the project.
        // But for a scalable ERP, subcollection is better. Let's support subcollection fetching.
        
        db.collection("projects").document(projectId).collection("financials")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        self?.transactions = []
                        return
                    }
                    
                    self?.transactions = documents.compactMap { try? .data(as: FinancialRecord.self) }
                }
            }
    }
    
    func addTransaction(projectId: String, transaction: FinancialRecord) {
        do {
            try db.collection("projects").document(projectId).collection("financials").document(transaction.id).setData(from: transaction)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
