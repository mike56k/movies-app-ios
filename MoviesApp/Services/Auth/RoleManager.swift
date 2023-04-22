import Foundation

enum Role: Int, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    
    case guest
    case user
    case admin
}

final class RoleManager: ObservableObject {
    
    private enum Constants {
        static let currentRoleKey = "current_role"
    }
    
    static let shared = RoleManager()
    private let userDefaults = UserDefaults.standard
    
    @Published private var hiddenCurrentRole: Role = .guest
    var currentRole: Role {
        get {
            return hiddenCurrentRole
        }
        set {
            guard newValue != hiddenCurrentRole else {
                return
            }
            
            hiddenCurrentRole = newValue
            userDefaults.set(newValue.rawValue, forKey: Constants.currentRoleKey)
        }
    }
    
    init() {
        readStoredCurrentRole()
    }
    
    private func readStoredCurrentRole() {
        let rawValue = userDefaults.integer(forKey: Constants.currentRoleKey)
        if let role = Role(rawValue: rawValue) {
            hiddenCurrentRole = role
        }
    }
    
}
