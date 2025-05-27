import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let email: String
    let password: String
    let createdAt: Date
    
    init(email: String, password: String) {
        self.id = UUID()
        self.email = email
        self.password = password
        self.createdAt = Date()
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
} 
