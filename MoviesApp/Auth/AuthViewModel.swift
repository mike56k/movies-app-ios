import SwiftUI

final class AuthViewModel: ObservableObject {
    
    func titleForRole(role: Role) -> String {
        switch role {
        case .guest:
            return "Гость"
            
        case .user:
            return "Пользователь"
            
        case .admin:
            return "Админ"
        }
    }
    
    var currentRole: Role {
        return RoleManager.shared.currentRole
    }
    
    func changeCurrentRole(newRole: Role) {
        RoleManager.shared.currentRole = newRole
        objectWillChange.send()
    }
    
}
