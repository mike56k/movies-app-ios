import SwiftUI
import Combine

final class FilmsFeedViewModel: ObservableObject {
    
    enum FilmsFeedState {
        case showContent(films: [FilmFeedModel])
        case searching
        case serverError
        case unknownError
    }
    
    @Published var filmsFeedState: FilmsFeedState = .searching
    
    func fetchFilms(searchText: String) async {
        var result: [FilmFeedModel] = []
        let newFilmsFeedState: FilmsFeedState
        
        result = await NetworkAPI.getFeed(searchText: searchText, offset: 0)
        newFilmsFeedState = .showContent(films: result)
        
        await MainActor.run {
            filmsFeedState = newFilmsFeedState
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

//class ContentDataSource: ObservableObject {
//
//    @Published var items = [ListItem]()
//    @Published var isLoadingPage = false
//    private var currentPage = 1
//    private var canLoadMorePages = true
//
//    init() {
//        loadMoreContent()
//    }
//
//    func loadMoreContentIfNeeded(currentItem item: ListItem?) {
//        guard let item = item else {
//          loadMoreContent()
//          return
//        }
//
//        let thresholdIndex = items.index(items.endIndex, offsetBy: -5)
//        if items.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
//          loadMoreContent()
//        }
//    }
//
//    private func loadMoreContent() {
//        guard !isLoadingPage && canLoadMorePages else {
//          return
//        }
//
//        isLoadingPage = true
//
//        let url = URL(string: "https://s3.eu-west-2.amazonaws.com/com.donnywals.misc/feed-\(currentPage).json")!
//        URLSession.shared.dataTaskPublisher(for: url)
//          .map(\.data)
//          .decode(type: ListResponse.self, decoder: JSONDecoder())
//          .receive(on: DispatchQueue.main)
//          .handleEvents(receiveOutput: { response in
//            self.canLoadMorePages = response.hasMorePages
//            self.isLoadingPage = false
//            self.currentPage += 1
//          })
//          .map({ response in
//            return self.items + response.items
//          })
//          .catch({ _ in Just(self.items) })
//          .assign(to: $items)
//    }
//
//}
