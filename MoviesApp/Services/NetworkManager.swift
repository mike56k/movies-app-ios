import SwiftUI

enum NetworkManagerError: Error {
    case invalidURL
    case invalidServerResponse
}

protocol NetworkManager {
    func fetchFeed(with searchText: String) async throws -> [FilmFeedModel]
}

final class NetworkManagerImpl: NetworkManager {
    
    func fetchFeed(with searchText: String) async throws-> [FilmFeedModel] {
        let request = buildURLRequest(for: searchText)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
          throw NetworkManagerError.invalidServerResponse
        }
        let decodedFilms = try JSONDecoder().decode([FilmFeedModel].self, from: data)
        return decodedFilms
    }
    
    private func buildURLRequest(for searchText: String) -> URLRequest {
      let escapedSearchTerm = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
      let url = URL(string: "http://95.163.211.116:8155/Films/SearchFilms?searchQuery=\(escapedSearchTerm)&count=20&offset=0")!
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
//      request.setValue(WordsAPISecrets.apiKey, forHTTPHeaderField: WordsAPISecrets.apiKeyHeader)
//      request.setValue(WordsAPISecrets.apiHost, forHTTPHeaderField: WordsAPISecrets.apiHostHeader)
      return request
    }
    
}
