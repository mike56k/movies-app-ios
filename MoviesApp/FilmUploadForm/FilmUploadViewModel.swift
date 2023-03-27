import Foundation

final class FilmUploadViewModel: ObservableObject {
                
    func uploadFilm(url: URL) async {
        await NetworkAPI.uploadTrailer(trailerUrl: url)
    }
    
}
