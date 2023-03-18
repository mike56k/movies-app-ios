import Foundation

final class FilmUploadViewModel: ObservableObject {
                
    func uploadTrailer(url: URL) async {
        await NetworkAPI.uploadTrailer(trailerUrl: url)
    }
    
}
