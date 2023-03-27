import SwiftUI

final class FilmDetailsViewModel: ObservableObject {
    
    @Published var filmModel: FilmDetailsModel? = nil
    
    func loadFilmDetails(filmId: Int) async {
        let result = await NetworkAPI.getFilmDetails(by: filmId)
        
        await MainActor.run {
            filmModel = result
        }
    }
    
}
