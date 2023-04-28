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
        guard let userInfo = await NetworkAPI.getUserInfo() else {
            assertionFailure("No user id")
            return
        }
        
        // TODO: Make a service to store userId
        UserDefaults.standard.set(userInfo.userId, forKey: "user_id")
        objectWillChange.send()
    }
    
    var currentUserId: Int {
        UserDefaults.standard.integer(forKey: "user_id")
    }
    
}
