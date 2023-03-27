import Foundation

final class FilmUploadViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var engName = ""
    @Published var description = ""
    @Published var yearOfRelease: Int = 2023
    @Published var length: String = ""
    @Published var videoURL: URL?
    @Published var isSending: Bool = false
    
    func uploadFilm() async {
        guard let videoURL = videoURL else {
            return
        }
        
        await MainActor.run {
            isSending = true
        }
        
        let trailerFileName = await NetworkAPI.uploadTrailer(trailerUrl: videoURL)
        
        await NetworkAPI.uploadFilmModel(film: FilmUploadModel(name: name,
                                                               engName: engName,
                                                               description: description,
                                                               yearOfRelease: yearOfRelease,
                                                               length: Int(length) ?? 0,
                                                               trailerFileName: trailerFileName,
                                                               filmTypeId: 1,
                                                               countriesIds: [1],
                                                               genresIds: [1],
                                                               personDTO: []))
        
        await MainActor.run {
            isSending = false
        }
    }
    
}
