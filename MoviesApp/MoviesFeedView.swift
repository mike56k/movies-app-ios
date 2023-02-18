import SwiftUI

struct MoviesFeedView: View {
    let films: [Film]
    
    var body: some View {
        ScrollView {
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
    }
    
    @State private var searchText = ""
    
}
