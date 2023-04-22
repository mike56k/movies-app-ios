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
        let userId = await NetworkAPI.getUserId()
        print(userId)
    }
    
}
