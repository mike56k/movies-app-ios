import SwiftUI

final class FilmDetailsViewModel: ObservableObject {
    let filmId: Int
    
    init(filmId: Int) {
        self.filmId = filmId
    }
    
    @Published var filmModel: FilmDetailsModel? = nil
    @Published var actorSearchText: String = ""
    
    func loadFilmDetails(filmId: Int) async {
        let result = await NetworkAPI.getFilmDetails(by: filmId)
        
        await MainActor.run {
            filmModel = result
        }
    }
    
    func getMediaUrl(name: String, type: Int) -> URL? {
        
        // TODO: Refactor -> Make MediaType enum + URLs to service
        
        if type == 1 || type == 2 {
            return URL(string: "http://95.163.211.116:8001/" + (name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""))
        }
        
        if type == 3 {
            return URL(string: "http://95.163.211.116:8001/trailers/" + (name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""))
        }
        
        return nil
    }
    
    func deleteComment(with id: Int) async {
        await NetworkAPI.deleteComment(commentId: id)
        await loadFilmDetails(filmId: filmId)
    }
    
}
