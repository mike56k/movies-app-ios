import SwiftUI

final class FilmUploadViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var engName = ""
    @Published var description = ""
    @Published var yearOfRelease: Int = 2023
    @Published var length: String = ""
    @Published var videoURL: URL?
    @Published var posterImage: UIImage?
    @Published var isSending: Bool = false
    
    func uploadFilm() async {
        guard let videoURL = videoURL else {
            return
        }
        
        guard let image = posterImage else {
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
                                                               poster: Poster(imageBase64: image.base64!, extension: ".png"),
                                                               filmTypeId: 1,
                                                               countriesIds: [1],
                                                               genresIds: [1],
                                                               personDTO: [],
                                                               filmImages: []))
        
        await MainActor.run {
            isSending = false
        }
    }
    
}

extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}
