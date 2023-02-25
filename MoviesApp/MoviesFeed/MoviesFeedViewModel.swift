import SwiftUI
import Combine

final class MoviesFeedViewModel: ObservableObject {
    
    enum MoviesFeedState {
        case showContent(films: [FilmFeedModel])
        case searching
        case serverError
        case unknownError
    }
    
    @Published var moviesFeedState: MoviesFeedState = .searching
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    private let networkManager: NetworkManager
        
    func getFilms(for searchText: String) async {
        var result: [FilmFeedModel] = []
        let newMoviesFeedState: MoviesFeedState
        
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            result = try await networkManager.fetchFeed(with: searchText)
            newMoviesFeedState = .showContent(films: result)
        }
        catch NetworkManagerError.invalidServerResponse, NetworkManagerError.invalidURL {
            newMoviesFeedState = .serverError
        }
        catch {
            newMoviesFeedState = .unknownError
        }
        
        await MainActor.run {
            moviesFeedState = newMoviesFeedState
        }
    }
    
}

final class DebounceObject: ObservableObject {
    @Published var text: String = ""
    @Published var debouncedText: String = ""
    private var bag = Set<AnyCancellable>()
    
    init(dueTime: TimeInterval = 0.7) {
        $text
            .removeDuplicates()
            .debounce(for: .seconds(dueTime), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.debouncedText = value
            })
            .store(in: &bag)
    }
    
}
