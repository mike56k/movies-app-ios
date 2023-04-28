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

    func get(url: String, parameters: Parameters?, headers: HTTPHeaders? = nil) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                parameters: parameters,
                headers: headers,
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
    
    func post<Parameters: Encodable>(url: String, parameters: Parameters?, headers: HTTPHeaders?) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .post, parameters: parameters, encoder: .json, headers: headers)
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
    
    func upload(url: String, headers: HTTPHeaders?, multipartFormData: @escaping (MultipartFormData) -> Void) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            session.upload(multipartFormData: multipartFormData,
                           to: url,
                           method: .post,
                           headers: headers)
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
    
    func delete(url: String, parameters: Parameters?, headers: HTTPHeaders? = nil) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .delete, parameters: parameters, headers: headers)
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
