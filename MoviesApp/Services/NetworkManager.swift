import SwiftUI

protocol NetworkManager {
    func fetchFeed() async throws -> [FilmFeedModel]
}

final class NetworkManagerImpl: NetworkManager {
    
    private enum NetworkManagerError: Error {
        case invalidURL
    }
    
    func fetchFeed() async throws -> [FilmFeedModel] {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=album") else {
            throw NetworkManagerError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decodedFilms = try JSONDecoder().decode([FilmFeedModel].self, from: data)
        return decodedFilms
    }
    
}
