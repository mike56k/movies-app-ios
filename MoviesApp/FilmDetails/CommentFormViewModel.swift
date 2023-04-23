import SwiftUI

final class CommentFormViewModel: ObservableObject {
    let filmId: Int
    @Published var commentText: String = ""
    @Published var rating: Float = 5
    
    init(filmId: Int) {
        self.filmId = filmId
    }
    
    func sendComment() async -> Bool {
        guard !commentText.isEmpty else {
            return false
        }
        
        let userId = UserDefaults.standard.integer(forKey: "user_id")
        guard userId != 0 else {
            print("No user id when sending comment")
            return false
        }
        
        return await NetworkAPI.createComment(comment: CommentCreateModel(userId: userId, filmId: filmId, text: commentText, stars: Int(rating)))
    }
    
}
