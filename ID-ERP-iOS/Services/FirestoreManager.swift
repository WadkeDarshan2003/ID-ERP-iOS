import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager: NSObject, ObservableObject {
    static let shared = FirestoreManager()
    
    @Published var projects: [Project] = []
    @Published var tasks: [Task] = []
    @Published var users: [User] = []
    @Published var activityLogs: [ActivityLog] = []
    @Published var documents: [Document] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    // MARK: - Projects
    func fetchProjects() {
        isLoading = true
        errorMessage = nil
        
        db.collection("projects").order(by: "created_at", descending: true).addSnapshotListener { [weak self] querySnapshot, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    Logger.error("Error fetching projects: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    self?.projects = []
                    return
                }
                
                do {
                    self?.projects = try documents.compactMap { try $0.data(as: Project.self) }
                } catch {
                    self?.errorMessage = error.localizedDescription
                    Logger.error("Error decoding projects: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Fetch only projects where user is in team (for vendor access control)
    func fetchUserProjects(userId: String) {
        isLoading = true
        errorMessage = nil
        
        db.collection("projects").whereField("team", arrayContains: userId)
            .order(by: "created_at", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        Logger.error("Error fetching user projects: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents else {
                        self?.projects = []
                        return
                    }
                    
                    do {
                        self?.projects = try documents.compactMap { try $0.data(as: Project.self) }
                    } catch {
                        self?.errorMessage = error.localizedDescription
                        Logger.error("Error decoding user projects: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func createProject(_ project: Project) {
        let projectData: [String: Any?] = [
            "id": project.id,
            "tenantId": project.tenantId,
            "name": project.name,
            "description": project.description,
            "status": project.status,
            "type": project.type.rawValue,
            "category": project.category.rawValue,
            "start_date": Timestamp(date: project.startDate),
            "end_date": project.endDate.map { Timestamp(date: $0) },
            "deadline": project.deadline.map { Timestamp(date: $0) },
            "budget": project.budget,
            "initial_budget": project.initialBudget,
            "owner": project.owner,
            "created_by": project.createdBy,
            "created_at": Timestamp(date: project.createdAt),
            "client_id": project.clientId,
            "client_ids": project.clientIds,
            "lead_designer_id": project.leadDesignerId,
            "team_members": project.teamMembers,
            "team": project.team,
            "vendor_ids": project.vendorIds,
            "hidden_vendors": project.hiddenVendors,
            "thumbnail": project.thumbnail,
            "designer_charge_percentage": project.designerChargePercentage
        ]
        
        db.collection("projects").document(project.id).setData(projectData.compactMapValues { $0 }) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                Logger.error("Error creating project: \(error.localizedDescription)")
            }
        }
    }
    
    func updateProject(_ project: Project) {
        let projectData: [String: Any?] = [
            "name": project.name,
            "description": project.description,
            "status": project.status,
            "type": project.type.rawValue,
            "category": project.category.rawValue,
            "end_date": project.endDate.map { Timestamp(date: $0) },
            "deadline": project.deadline.map { Timestamp(date: $0) },
            "budget": project.budget,
            "initial_budget": project.initialBudget,
            "client_ids": project.clientIds,
            "lead_designer_id": project.leadDesignerId,
            "team_members": project.teamMembers,
            "team": project.team,
            "vendor_ids": project.vendorIds,
            "hidden_vendors": project.hiddenVendors,
            "thumbnail": project.thumbnail,
            "designer_charge_percentage": project.designerChargePercentage,
            "updated_at": Timestamp(date: Date())
        ]
        
        db.collection("projects").document(project.id).updateData(projectData.compactMapValues { $0 }) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                Logger.error("Error updating project: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteProject(id: String) {
        db.collection("projects").document(id).delete { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                Logger.error("Error deleting project: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Tasks
    func fetchTasks(for projectId: String? = nil) {
        isLoading = true
        errorMessage = nil
        
        var query: Query = db.collection("tasks")
        
        if let projectId = projectId {
            query = query.whereField("project_id", isEqualTo: projectId)
        }
        
        query.order(by: "created_at", descending: true).addSnapshotListener { [weak self] querySnapshot, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    Logger.error("Error fetching tasks: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    self?.tasks = []
                    return
                }
                
                do {
                    self?.tasks = try documents.compactMap { try $0.data(as: Task.self) }
                } catch {
                    self?.errorMessage = error.localizedDescription
                    Logger.error("Error decoding tasks: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func createTask(_ task: Task) {
        let taskData: [String: Any?] = [
            "id": task.id,
            "project_id": task.projectId,
            "title": task.title,
            "description": task.description,
            "status": task.status,
            "progress": task.progress,
            "priority": task.priority,
            "category": task.category,
            "assignee": task.assignee,
            "assignee_id": task.assigneeId,
            "due_date": task.dueDate.map { Timestamp(date: $0) },
            "start_date": task.startDate.map { Timestamp(date: $0) },
            "created_at": Timestamp(date: task.createdAt),
            "dependencies": task.dependencies,
            "documents": task.documents
        ]
        
        db.collection("tasks").document(task.id).setData(taskData.compactMapValues { $0 }) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                Logger.error("Error creating task: \(error.localizedDescription)")
            }
        }
    }
    
    func updateTask(_ task: Task) {
        let taskData: [String: Any?] = [
            "title": task.title,
            "description": task.description,
            "status": task.status,
            "progress": task.progress,
            "priority": task.priority,
            "category": task.category,
            "assignee": task.assignee,
            "assignee_id": task.assigneeId,
            "due_date": task.dueDate.map { Timestamp(date: $0) },
            "start_date": task.startDate.map { Timestamp(date: $0) },
            "dependencies": task.dependencies,
            "documents": task.documents
        ]
        
        db.collection("tasks").document(task.id).updateData(taskData.compactMapValues { $0 }) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                Logger.error("Error updating task: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteTask(id: String) {
        db.collection("tasks").document(id).delete { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                Logger.error("Error deleting task: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Users
    func fetchUsers() {
        isLoading = true
        errorMessage = nil
        
        db.collection("users").order(by: "created_at", descending: true).addSnapshotListener { [weak self] querySnapshot, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    Logger.error("Error fetching users: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    self?.users = []
                    return
                }
                
                do {
                    self?.users = try documents.compactMap { try $0.data(as: User.self) }
                } catch {
                    self?.errorMessage = error.localizedDescription
                    Logger.error("Error decoding users: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Activity Logs
    func fetchActivityLogs(for projectId: String? = nil) {
        var query: Query = db.collection("activity_logs")
        
        if let projectId = projectId {
            query = query.whereField("project_id", isEqualTo: projectId)
        }
        
        query.order(by: "timestamp", descending: true).addSnapshotListener { [weak self] querySnapshot, error in
            if let error = error {
                Logger.error("Error fetching logs: \(error.localizedDescription)")
                return
            }
            
            self?.activityLogs = querySnapshot?.documents.compactMap { try? $0.data(as: ActivityLog.self) } ?? []
        }
    }
    
    // MARK: - Documents
    func fetchDocuments(for projectId: String) {
        let query = db.collection("projects").document(projectId).collection("documents")
        
        query.addSnapshotListener { [weak self] querySnapshot, error in
            if let error = error {
                Logger.error("Error fetching documents: \(error.localizedDescription)")
                return
            }
            
            var docs = querySnapshot?.documents.compactMap { try? $0.data(as: Document.self) } ?? []
            // Sort by uploadDate descending
            docs.sort { ($0.uploadDate ?? "") > ($1.uploadDate ?? "") }
            
            self?.documents = docs
        }
    }
}
