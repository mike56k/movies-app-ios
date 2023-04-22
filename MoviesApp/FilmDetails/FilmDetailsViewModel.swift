import SwiftUI

final class FilmDetailsViewModel: ObservableObject {
    
    @Published var filmModel: FilmDetailsModel? = nil
    
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
    
}
