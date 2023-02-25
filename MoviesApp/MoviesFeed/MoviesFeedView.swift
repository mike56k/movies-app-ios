import SwiftUI

struct MoviesFeedView: View {
    @StateObject var viewModel: MoviesFeedViewModel
    @StateObject var debounceObject = DebounceObject()

    var body: some View {
        ScrollView {
            switch viewModel.moviesFeedState {
            case .showContent(let films):
                LazyVStack {
                    ForEach(films, id: \.id) { film in
                        NavigationLink {
                            MovieDetailsView(model: film)
                        } label: {
                            MovieCardView(model: film)
                                .padding(.horizontal, 10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .searchable(text: $debounceObject.text)
                .onChange(of: debounceObject.debouncedText) { searchText in
                    Task {
                        await viewModel.getFilms(for: searchText)
                    }
                }
                
            case .searching:
                stretch(view:
                    VStack {
                        ProgressView()
                        Text("Идет поиск...")
                    }
                )
                
            case .serverError:
                stretch(view: Text("Ошибка на сервере :("))
                
            case .unknownError:
                stretch(view: Text("Неизвестная ошибка :("))
            }

        }
        .background(Color.Palette.defaultBackground)
        .navigationTitle("Фильмы")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "slider.horizontal.3")
            }
            .buttonStyle(PlainButtonStyle())
        }
        .task {
            await viewModel.getFilms(for: "")
        }
        .refreshable {
            await viewModel.getFilms(for: "")
        }
    }
    
//    @State private var searchText = ""
    
//    var searchResults: [FilmFeedModel] {
//        if searchText.isEmpty {
//            return films
//        } else {
//            return films.filter { $0.name.contains(searchText) }
//        }
//    }
    
    private func stretch(view: some View) -> some View {
        HStack {
            Spacer()
            view
            Spacer()
        }
    }
    
}
