import Foundation

class UserService: ObservableObject {
    @Published var currentUser: User?
    private let userDefaultsKey = "users"
    
    private var users: [User] {
        get {
            if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
                return (try? JSONDecoder().decode([User].self, from: data)) ?? []
            }
            return []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            }
        }
    }
    
    init() {
        // Create a test user if none exists
        if users.isEmpty {
            let testUser = User(email: "test@test.com", password: "password123")
            users.append(testUser)
        }
        
        // check if tthere is a saved login session
        if let data = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            self.currentUser = user
        }
    }
    
    func register(email: String, password: String) -> Bool {
        guard !users.contains(where: { $0.email == email }) else {
            return false // User already exists
        }
        
        let newUser = User(email: email, password: password)
        users.append(newUser)
        currentUser = newUser
        saveCurrentUser()
        return true
    }
    
    func login(email: String, password: String) -> Bool {
        guard let user = users.first(where: { $0.email == email && $0.password == password }) else {
            return false
        }
        currentUser = user
        saveCurrentUser()
        return true
    }
    
    func logout() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
    
    private func saveCurrentUser() {
        if let user = currentUser,
           let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }
} 
