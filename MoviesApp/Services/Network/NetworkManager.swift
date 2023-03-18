import Foundation
import Alamofire

actor NetworkManager: GlobalActor {
    static let shared = NetworkManager()
    private init() {}
    
    private let session: Session = {
        let manager = ServerTrustManager(evaluators: [NetworkConstants.ip: DisabledTrustEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        return Session(configuration: configuration, serverTrustManager: manager)
    }()
    
    private let maxWaitTime = 15.0
    var commonHeaders: HTTPHeaders = [
        "user_id": "123",
        "token": "xxx-xx"
    ]
    
//    let headers: HTTPHeaders = [
//        "Authorization": "Bearer YourAccessToken"
//    ]

    func get(url: String, parameters: Parameters?) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                parameters: parameters,
                headers: commonHeaders,
                requestModifier: { $0.timeoutInterval = self.maxWaitTime }
            )
            .responseData { response in
                switch(response.result) {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: self.handleError(error: error))
                }
            }
        }
    }
    
    func post<Parameters: Encodable>(url: String, parameters: Parameters?) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .post, parameters: parameters, encoder: .json)
                .responseData { response in
                    switch(response.result) {
                    case let .success(data):
                        continuation.resume(returning: data)
                    case let .failure(error):
                        continuation.resume(throwing: self.handleError(error: error))
                    }
                }
        }
    }
    
    func upload(url: String, multipartFormData: @escaping (MultipartFormData) -> Void) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            session.upload(multipartFormData: multipartFormData,
                           to: url,
                           method: .post,
                           headers: [
                                "Content-Type": "multipart/form-data"
                           ])
            .validate()
            .responseData { response in
                switch(response.result) {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: self.handleError(error: error))
                }
            }
        }
    }
    
    private func handleError(error: AFError) -> Error {
        if let underlyingError = error.underlyingError {
            let nserror = underlyingError as NSError
            let code = nserror.code
            if code == NSURLErrorNotConnectedToInternet ||
                code == NSURLErrorTimedOut ||
                code == NSURLErrorInternationalRoamingOff ||
                code == NSURLErrorDataNotAllowed ||
                code == NSURLErrorCannotFindHost ||
                code == NSURLErrorCannotConnectToHost ||
                code == NSURLErrorNetworkConnectionLost
            {
                var userInfo = nserror.userInfo
                userInfo[NSLocalizedDescriptionKey] = "Unable to connect to the server"
                let currentError = NSError(
                    domain: nserror.domain,
                    code: code,
                    userInfo: userInfo
                )
                return currentError
            }
        }
        return error
    }
    
}
