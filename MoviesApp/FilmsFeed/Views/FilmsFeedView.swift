import SwiftUI

struct FilmsFeedView: View {
    @StateObject var viewModel = FilmsFeedViewModel()
    @StateObject var debounceObject = DebounceObject()
    
    var body: some View {
        Group {
            switch viewModel.filmsFeedState {
            case .showContent(let films):
                ScrollView {
                    LazyVStack {
                        ForEach(films, id: \.id) { film in
                            NavigationLink {
                                FilmDetailsView(model: film)
                            } label: {
                                FilmCardView(model: film)
                                    .padding(.horizontal, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
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
                    await viewModel.fetchFilms(searchText: "")
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
                NavigationLink {
                    FilmUploadView()
                } label: {
                    Image(systemName: "plus.app")
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .task {
            await viewModel.fetchFilms(searchText: "")
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

//struct EndlessList: View {
//  @StateObject var dataSource = ContentDataSource()
//
//  var body: some View {
//    ScrollView {
//      LazyVStack {
//        ForEach(dataSource.items) { item in
//          Text(item.label)
//            .onAppear {
//              dataSource.loadMoreContentIfNeeded(currentItem: item)
//            }
//            .padding(.all, 30)
//        }
//
//        if dataSource.isLoadingPage {
//          ProgressView()
//        }
//      }
//    }
//  }
//}
