import SwiftUI
import AVKit

struct MoviesFeedView: View {
    let films: [Film]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(films, id: \.id) { film in
                    NavigationLink {
                        MovieDetailsView(model: film)
                    } label: {
                        MovieCard(model: film)
                            .padding(.horizontal, 10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .background(Color.defaultBackground)
        .navigationTitle("Фильмы")
    }
}

struct MovieCard: View {
    let model: Film
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: model.coverImage)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 250)
            .clipped()

            HStack {
                VStack(alignment: .leading) {
                    Text(model.name)
                    HStack {
                        Text(String(model.yearOfRelease))
                        Spacer()
                        Text("Рейтинг: \(model.rating)")
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color.cellBackground)
        .cornerRadius(20)
    }
    
}

struct MovieDetailsView: View {
    let model: Film
    
    var body: some View {
        List {
            Section {
                descriptionRow(title: "Год выпуска",
                               value: "\(model.yearOfRelease)")
                descriptionRow(title: "Ориг. название",
                               value: "\(model.alternativeName)")
                descriptionRow(title: "Рейтинг",
                               value: "\(model.rating)")
                descriptionRow(title: "Длительность",
                               value: "\(model.length) минут")
            } header: {
                Text("Факты")
            }
            
            Section {
                Text(model.description)
            } header: {
                Text("Описание")
            }
            
            if let url = URL(string: model.trailerUrl) {
                NavigationLink {
                    TrailerPlayer(trailerUrl: url)
                } label: {
                    Text("Трейлер")
                }
            }

        }
        .listStyle(.sidebar)
    }
    
    @ViewBuilder
    private func descriptionRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }
    
}

struct TrailerPlayer: View {
    
    init(trailerUrl: URL) {
        _player = State(initialValue: AVPlayer(url: trailerUrl))
    }
    
    var body: some View {
        VideoPlayer(player: player)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
    
    @State private var player: AVPlayer
    
}
