import SwiftUI
import Combine

final class FilmsFeedViewModel: ObservableObject {
    
    enum FilmsFeedState {
        case showContent
        case searching
        case serverError
        case unknownError
    }
    
    @Published var films: [FilmFeedModel] = []
    @Published var filmsFeedState: FilmsFeedState = .searching
    @Published var isLoadingPage: Bool = false
    @Published var nothingToLoad: Bool = false
    
    func fetchFilms(searchText: String) async {
        let newFilmsFeedState: FilmsFeedState
        let result = await NetworkAPI.getFeed(searchText: searchText, offset: 0)
        newFilmsFeedState = .showContent
        
        await MainActor.run {
            filmsFeedState = newFilmsFeedState
            films = result
        }
    }
    
    func fetchMoreFilms(searchText: String) async {
        let result: [FilmFeedModel] = await NetworkAPI.getFeed(searchText: searchText, offset: films.count + 20)
        
        await MainActor.run {
            films += result
            nothingToLoad = result.isEmpty
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
