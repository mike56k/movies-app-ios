import Foundation
import Alamofire
import GoogleSignIn

final class NetworkAPI {
    
    static func getFeed(searchText: String, offset: Int) async -> [FilmFeedModel] {
        let escapedSearchTerm = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        do {
            let data = try await NetworkManager.shared.get(url: NetworkConstants.Route.Films.searchFilms + "?searchQuery=\(escapedSearchTerm)&count=20&offset=\(offset)",
                                                           parameters: nil)
            let result: [FilmFeedModel] = try self.parseData(data: data)
            return result
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    static func getFilmDetails(by id: Int) async -> FilmDetailsModel? {
        do {
            let data = try await NetworkManager.shared.get(url: NetworkConstants.Route.Films.getById + "/" + String(id),
                                                           parameters: nil)
            let result: FilmDetailsModel = try self.parseData(data: data)
            return result
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func getFilmTypes() async -> [FilmTypeModel] {
        do {
            let data = try await NetworkManager.shared.get(url: NetworkConstants.Route.FilmTypes.getFilmTypes,
                                                           parameters: nil)
            let result: [FilmTypeModel] = try self.parseData(data: data)
            return result
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    static func uploadFilmModel(film: FilmUploadModel) async {
        do {
            let data = try await NetworkManager.shared.post(url: NetworkConstants.Route.Films.uploadModel, parameters: film)
            print(String(decoding: data, as: UTF8.self))
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func uploadTrailer(trailerUrl: URL) async -> String {
        do {
            let data = try await NetworkManager.shared.upload(url: NetworkConstants.Route.Films.uploadTrailer,
                                                              multipartFormData: { (multipartFormData) in
                multipartFormData.append(trailerUrl, withName: "file", fileName: "video.mp4", mimeType: "video/mp4")
            })
            return String(decoding: data, as: UTF8.self)
        } catch let error {
            print(error.localizedDescription)
            return ""
        }
    }
    
    static func getUserId() async -> String {
        do {
            let data = try await NetworkManager.shared.get(url: NetworkConstants.Route.Users.getId, parameters: nil, headers: headersWithToken)
            return String(decoding: data, as: UTF8.self)
        } catch let error {
            print(error.localizedDescription)
            return ""
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
    
    private static var headersWithToken: HTTPHeaders? {
        guard let currentUser = GIDSignIn.sharedInstance.currentUser else {
            return nil
        }
        Task {
            try await currentUser.refreshTokensIfNeeded()
        }
        guard let idToken = currentUser.idToken else {
            return nil
        }
        return [
            "Authorization": idToken.tokenString
        ]
    }
    
}
