import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager: NSObject, ObservableObject {
    static let shared = FirestoreManager()
    
    @Published var projects: [Project] = []
    @Published var tasks: [Task] = []
    @Published var users: [User] = []
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
                    print("Error fetching projects: \(error.localizedDescription)")
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
                    print("Error decoding projects: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func createProject(_ project: Project) {
        let projectData = [
            "id": project.id,
            "name": project.name,
            "description": project.description,
            "status": project.status,
            "start_date": Timestamp(date: project.startDate),
            "end_date": project.endDate.map { Timestamp(date: $0) },
            "budget": project.budget,
            "owner": project.owner,
            "team": project.team,
            "created_at": Timestamp(date: project.createdAt)
        ] as [String: Any?]
        
        db.collection("projects").document(project.id).setData(projectData.compactMapValues { $0 }) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                print("Error creating project: \(error.localizedDescription)")
            }
        }
    }
    
    func updateProject(_ project: Project) {
        let projectData = [
            "name": project.name,
            "description": project.description,
            "status": project.status,
            "budget": project.budget,
            "team": project.team
        ] as [String: Any]
        
        db.collection("projects").document(project.id).updateData(projectData) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                print("Error updating project: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteProject(id: String) {
        db.collection("projects").document(id).delete { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                print("Error deleting project: \(error.localizedDescription)")
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
                    print("Error fetching tasks: \(error.localizedDescription)")
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
                    print("Error decoding tasks: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func createTask(_ task: Task) {
        let taskData = [
            "id": task.id,
            "project_id": task.projectId,
            "title": task.title,
            "description": task.description,
            "status": task.status,
            "priority": task.priority,
            "assignee": task.assignee,
            "due_date": task.dueDate.map { Timestamp(date: $0) },
            "created_at": Timestamp(date: task.createdAt)
        ] as [String: Any?]
        
        db.collection("tasks").document(task.id).setData(taskData.compactMapValues { $0 }) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                print("Error creating task: \(error.localizedDescription)")
            }
        }
    }
    
    func updateTask(_ task: Task) {
        let taskData = [
            "title": task.title,
            "description": task.description,
            "status": task.status,
            "priority": task.priority,
            "assignee": task.assignee
        ] as [String: Any]
        
        db.collection("tasks").document(task.id).updateData(taskData) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                print("Error updating task: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteTask(id: String) {
        db.collection("tasks").document(id).delete { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                print("Error deleting task: \(error.localizedDescription)")
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
                    print("Error fetching users: \(error.localizedDescription)")
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
                    print("Error decoding users: \(error.localizedDescription)")
                }
            }
        }
    }
}
