import SwiftUI

struct FilmsFeedView: View {
    @StateObject var viewModel = FilmsFeedViewModel()
    @StateObject var debounceObject = DebounceObject()
    @EnvironmentObject var roleManager: RoleManager

    var body: some View {
        Group {
            switch viewModel.filmsFeedState {
            case .showContent:
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.films, id: \.id) { film in
                            NavigationLink {
                                FilmDetailsView(viewModel: FilmDetailsViewModel(filmId: film.id))
                            } label: {
                                FilmCardView(model: film)
                                    .padding(.horizontal, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        Group {
                            if viewModel.nothingToLoad {
                                Text("Больше фильмов нет")
                            }
                            else {
                                ProgressView()
                            }
                        }
                        .onAppear {
                            Task {
                                await viewModel.fetchMoreFilms(searchText: debounceObject.debouncedText)
                            }
                        }
                    }
                }
                .searchable(text: $debounceObject.text)
                .onChange(of: debounceObject.debouncedText) { searchText in
                    Task {
                        await viewModel.fetchFilms(searchText: searchText)
                    }
                }
                .refreshable {
                    await viewModel.fetchFilms(searchText: debounceObject.debouncedText)
                }

            case .searching:
                stretch(view:
                    VStack {
                        ProgressView()
                        Text("Идет поиск...")
                    }
                )
                .task {
                    await viewModel.fetchFilms(searchText: "")
                }
                
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isSettingsPresented = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $isSettingsPresented) {
                    FiltersView()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if roleManager.currentRole == .admin {
                    NavigationLink {
                        FilmUploadView()
                    } label: {
                        Image(systemName: "plus.app")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    @State private var isSettingsPresented = false
    
    private func stretch(view: some View) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                view
                Spacer()
            }
            Spacer()
        }
    }
    
}
