import SwiftUI

final class AuthViewModel: ObservableObject {
    
    @ObservedObject var roleManager = RoleManager.shared
    
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
    
}
