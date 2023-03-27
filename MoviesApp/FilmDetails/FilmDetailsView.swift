import SwiftUI

struct FilmDetailsView: View {
    let filmId: Int
    
    var body: some View {
        Group {
            if let model = viewModel.filmModel {
                List {
                    Section {
                        descriptionRow(title: "Год выпуска",
                                       value: "\(model.yearOfRelease)")
                        descriptionRow(title: "Ориг. название",
                                       value: "\(model.engName)")
                        descriptionRow(title: "Рейтинг",
                                       value: "\(model.rating)")
                        descriptionRow(title: "Длительность",
                                       value: "\(model.length) минут")
                        descriptionRow(title: "Жанры",
                                       value: model.genres.map { $0.name.capitalized }.joined(separator: ", "))
                        descriptionRow(title: "Страны производства",
                                       value: model.countries.map { $0.name }.joined(separator: ", "))
                    } header: {
                        Text("Факты")
                    }
                    
                    if !model.mediaFiles.isEmpty {
                        Section {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(model.mediaFiles, id: \.id) { mediaFile in
                                        AsyncImage(url: URL(string: "http://95.163.211.116:8001/" + mediaFile.path)) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxHeight: 300)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                }
                            }
                        } header: {
                            Text("Обложка")
                        }
                    }
                    
                    Section {
                        Text(model.description)
                    } header: {
                        Text("Описание")
                    }
                    
//                    if let trailerUrl = model.trailerUrl {
//                        if let url = URL(string: trailerUrl) {
//                            NavigationLink {
//                                TrailerPlayer(trailerUrl: url)
//                            } label: {
//                                Text("Трейлер")
//                            }
//                        }
//                    }
                }
                .listStyle(.sidebar)
            }
            else {
                ProgressView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.loadFilmDetails(filmId: filmId)
            }
        }
    }
    
    @StateObject private var viewModel = FilmDetailsViewModel()
    
    private func descriptionRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }
    
}
