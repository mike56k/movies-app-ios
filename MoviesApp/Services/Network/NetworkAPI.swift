import Foundation
import Alamofire

final class NetworkAPI {
    
    static func getFeed(searchText: String, offset: Int) async -> [FilmFeedModel] {
        let escapedSearchTerm = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        do {
            let data = try await NetworkManager.shared.get(url: NetworkConstants.Route.Film.searchFilms + "?searchQuery=\(escapedSearchTerm)&count=20&offset=\(offset)",
                                                           parameters: nil)
            let result: [FilmFeedModel] = try self.parseData(data: data)
            return result
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    static func uploadFilmModel(film: FilmUploadModel) async {
        do {
            let data = try await NetworkManager.shared.post(url: NetworkConstants.Route.Film.uploadModel, parameters: film)
            // TODO: Process result
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func uploadTrailer(trailerUrl: URL) async {
        do {
            let data = try await NetworkManager.shared.upload(url: NetworkConstants.Route.Film.uploadTrailer,
                                                              multipartFormData: { (multipartFormData) in
                multipartFormData.append(trailerUrl, withName: "file", fileName: "video.mp4", mimeType: "video/mp4")
            })
            // TODO: Process result
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private static func parseData<T: Decodable>(data: Data) throws -> T {
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data)
        else {
            throw NSError(
                domain: "NetworkAPIError",
                code: 3,
                userInfo: [NSLocalizedDescriptionKey: "JSON decode error"]
            )
        }
        return decodedData
    }
    
}