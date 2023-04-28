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
            let data = try await NetworkManager.shared.post(url: NetworkConstants.Route.Films.uploadModel, parameters: film, headers: headersWithToken)
            print(String(decoding: data, as: UTF8.self))
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func uploadTrailer(trailerUrl: URL) async -> String {
        do {
            guard let currentUser = GIDSignIn.sharedInstance.currentUser else {
                return ""
            }
            Task {
                try await currentUser.refreshTokensIfNeeded()
            }
            guard let idToken = currentUser.idToken else {
                return ""
            }
            
            let data = try await NetworkManager.shared.upload(url: NetworkConstants.Route.Films.uploadTrailer,
                                                              headers: [
                                                                "Content-Type": "multipart/form-data",
                                                                "Authorization": idToken.tokenString
                                                              ],
                                                              multipartFormData: { (multipartFormData) in
                multipartFormData.append(trailerUrl, withName: "file", fileName: "video.mp4", mimeType: "video/mp4")
            })
            return String(decoding: data, as: UTF8.self)
        } catch let error {
            print(error.localizedDescription)
            return ""
        }
    }
    
    static func getUserInfo() async -> UserInfo? {
        do {
            let data = try await NetworkManager.shared.get(url: NetworkConstants.Route.Users.getUserInfo, parameters: nil, headers: headersWithToken)
            let result: UserInfo = try self.parseData(data: data)
            return result
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func createComment(comment: CommentCreateModel) async -> Bool {
        do {
            let data = try await NetworkManager.shared.post(url: NetworkConstants.Route.Comments.createComment, parameters: comment, headers: headersWithToken)
            let stringData = String(decoding: data, as: UTF8.self)
            print(stringData)
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    static func deleteComment(commentId: Int) async {
        do {
            let data = try await NetworkManager.shared.delete(url: NetworkConstants.Route.Comments.deleteComment, parameters: ["commentId":commentId], headers: headersWithToken)
            print(String(decoding: data, as: UTF8.self))
        } catch let error {
            print(error.localizedDescription)
            return
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
        print(idToken.tokenString)
        return [
            "Authorization": idToken.tokenString
        ]
    }
    
}
