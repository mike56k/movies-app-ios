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
    
    func authorizeUser() async {
        guard let userId = await NetworkAPI.getUserId() else {
            assertionFailure("No user id")
            return
        }
        
        // TODO: Make a service to store userId
        UserDefaults.standard.set(userId, forKey: "user_id")
    }
    
}
