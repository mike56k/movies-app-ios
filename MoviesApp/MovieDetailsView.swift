import SwiftUI

struct MovieDetailsView: View {
    let model: FilmFeedModel
    
    var body: some View {
        List {
            Section {
//                descriptionRow(title: "Жанр",
//                               value: "\(model.genres)")
                descriptionRow(title: "Год выпуска",
                               value: "\(model.yearOfRelease)")
                descriptionRow(title: "Ориг. название",
                               value: "\(model.engName)")
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
        .navigationBarTitleDisplayMode(.inline)
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
