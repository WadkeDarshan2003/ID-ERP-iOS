import Foundation
import Firebase
import FirebaseStorage

class StorageManager: ObservableObject {
    static let shared = StorageManager()
    private let storage = Storage.storage()
    
    @Published var isUploading = false
    @Published var uploadProgress: Double = 0
    @Published var errorMessage: String?
    
    func uploadFile(data: Data, fileName: String, path: String, completion: @escaping (Result<String, Error>) -> Void) {
        isUploading = true
        uploadProgress = 0
        
        let storageRef = storage.reference().child(path).child(fileName)
        let metadata = StorageMetadata()
        metadata.contentType = "application/octet-stream" // Determine based on file type
        
        let uploadTask = storageRef.putData(data, metadata: metadata) { metadata, error in
            DispatchQueue.main.async {
                self.isUploading = false
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            DispatchQueue.main.async {
                self.uploadProgress = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
            }
        }
    }
}
