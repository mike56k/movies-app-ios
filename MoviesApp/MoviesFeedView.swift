import SwiftUI

struct MoviesFeedView: View {
    let films: [FilmFeedModel]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(searchResults, id: \.id) { film in
                    NavigationLink {
                        MovieDetailsView(model: film)
                    } label: {
                        MovieCardView(model: film)
                            .padding(.horizontal, 10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .background(Color.defaultBackground)
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
        .searchable(text: $searchText)
    }
    
    @State private var searchText = ""
    
    private var searchResults: [FilmFeedModel] {
        if searchText.isEmpty {
            return films
        } else {
            return films.filter { $0.name.contains(searchText) }
        }
    }
    
}
