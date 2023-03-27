import Foundation

final class FilmUploadViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var engName = ""
    @Published var description = ""
    @Published var yearOfRelease: Int = 2023
    @Published var length: String = ""
    @Published var videoURL: URL?
    
    func uploadFilm() async {
        guard let videoURL = videoURL else {
            return
        }
        
        let uploadedTrailerPath = await NetworkAPI.uploadTrailer(trailerUrl: videoURL)
        print(uploadedTrailerPath)
//        await NetworkAPI.uploadFilmModel(film: FilmUploadModel(name: name,
//                                                               engName: engName,
//                                                               description: description,
//                                                               yearOfRelease: yearOfRelease,
//                                                               length: Int(length) ?? 0,
//                                                               filmTypeId: 0,
//                                                               countriesIds: [],
//                                                               genresIds: [],
//                                                               personDTO: []))
    }
    
}
