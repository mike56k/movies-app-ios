import SwiftUI

struct FilmDetailsView: View {
    
    let filmId: Int
    
    var body: some View {
        Group {
            if let model = viewModel.filmModel {
                List {
                    factsSectionView(model: model)
                    mediaSectionView(model: model)
                    descriptionSectionView(model: model)
                    actorsSectionView(model: model)
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
    
    private func factsSectionView(model: FilmDetailsModel) -> some View {
        Section {
            descriptionRow(title: "Название",
                           value: "\(model.name)")
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
    }
    
    private func descriptionSectionView(model: FilmDetailsModel) -> some View {
        Section {
            Text(model.description)
        } header: {
            Text("Описание")
        }
    }
    
    private func actorsSectionView(model: FilmDetailsModel) -> some View {
        Section {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(model.filmPeople) { filmPerson in
                        ActorCardView(model: filmPerson.person)
                            .frame(maxWidth: 200)
                        Divider()
                    }
                }
            }
        } header: {
            HStack {
                Text("Актёры")
                
                Spacer()
                
                NavigationLink("Все") {
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            ForEach(model.filmPeople) { filmPerson in
                                ActorCardView(model: filmPerson.person)
                                Divider()
                            }
                        }
                        .padding()
                    }
                    .navigationTitle("Актеры фильма: " + model.name)
                }
            }
        }
    }
    
    private func commentsSectionView(model: FilmDetailsModel) -> some View {
        Section {
            Text("Коменты")
//            ScrollView(.vertical) {
//                VStack(spacing: 0) {
//                    ForEach(model.filmPeople) { filmPerson in
//                        ActorCardView(model: filmPerson.person)
//                            .frame(maxWidth: 200)
//                        Divider()
//                    }
//                }
//            }
        } header: {
            Text("Рецензии")
        }
    }
    
    @ViewBuilder
    private func mediaSectionView(model: FilmDetailsModel) -> some View {
        if !model.mediaFiles.isEmpty {
            Section {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(model.mediaFiles, id: \.id) { mediaFile in
                            if mediaFile.type == 1 || mediaFile.type == 2 {
                                AsyncImage(url: viewModel.getMediaUrl(name: mediaFile.path, type: mediaFile.type)) { image in
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
                }
            } header: {
                Text("Обложка")
            }
            
            if let filmMediaModel = model.mediaFiles.first(where: { $0.type == 3 }){
                if let url = viewModel.getMediaUrl(name: filmMediaModel.path, type: 3) {
                    NavigationLink {
                        TrailerPlayer(trailerUrl: url)
                    } label: {
                        Text("Трейлер")
                    }
                }
            }
        }
    }
    
    private func descriptionRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }
    
}
