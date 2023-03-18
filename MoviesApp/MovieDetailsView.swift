import SwiftUI

struct FilmDetailsView: View {
    let model: FilmFeedModel
    
    var body: some View {
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
            } header: {
                Text("Факты")
            }
            
            Section {
                Text(model.description)
            } header: {
                Text("Описание")
            }
            
            if let trailerUrl = model.trailerUrl {
                if let url = URL(string: trailerUrl) {
                    NavigationLink {
                        TrailerPlayer(trailerUrl: url)
                    } label: {
                        Text("Трейлер")
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func descriptionRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }
    
}
