import Foundation

enum Role: Int, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    
    case guest
    case user
    case admin
}

final class RoleManager {
    
    private enum Constants {
        static let currentRoleKey = "current_role"
    }
    
    static let shared = RoleManager()
    private let userDefaults = UserDefaults.standard
    
    var currentRole: Role {
        get {
            let rawValue = userDefaults.integer(forKey: Constants.currentRoleKey)
            guard let role = Role(rawValue: rawValue) else {
                return .guest
            }
            
            return role
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: Constants.currentRoleKey)
        }
    }
    
    init() {
    }
    
}
