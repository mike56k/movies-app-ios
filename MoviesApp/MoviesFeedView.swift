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
        .background(Color(uiColor: UIColor.systemGray5))
        .cornerRadius(20)
    }
    
}

struct MovieDetailsView: View {
    let model: Film
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(model.name)
                            .fontWeight(.heavy)
                            .font(.title)
                        
                        Divider()
                        
                        descriptionRow(title: "Год выпуска",
                                       value: "\(model.yearOfRelease)")
                        descriptionRow(title: "Оригинальное название",
                                       value: "\(model.alternativeName)")
                        descriptionRow(title: "Рейтинг",
                                       value: "\(model.rating)")
                        descriptionRow(title: "Длительность",
                                       value: "\(model.length) минут")
                        Divider()
                        
                        Text(model.description)
//                            .multilineTextAlignment(.leading)
//                            .lineLimit(nil)
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            Text("Трейлер")
                            VideoPlayer(player: AVPlayer(url: URL(string: model.trailerUrl)!))
                                .frame(height: 250)
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func descriptionRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Divider()
            Text(value)
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoviesFeedView(films: [Film(name: "Masha&Medved", alternativeName: "Suka", description: "Bla bla", year: 1899, rating: 23, length: 70, coverImage: "https://play-lh.googleusercontent.com/eBmMygVthqyk1dhXul2OC9Hj831L3CSoTIM_FbmGFEY6mQZRnZGqghRHT5fX-hbrdg"),
//                               Film(name: "Masha&Medved", alternativeName: "Suka", description: "Bla bla", year: 1899, rating: 23, length: 70, coverImage: "https://play-lh.googleusercontent.com/eBmMygVthqyk1dhXul2OC9Hj831L3CSoTIM_FbmGFEY6mQZRnZGqghRHT5fX-hbrdg")])
//    }
//}
//

//let videos = [
//    "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
//    "https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
//    "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
//    "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
//    "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
//    "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
//    "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
//    "https://storage.googleapis.com/gtv-videos-bucket/sample/Sintel.jpg",
//    "https://storage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
//    "https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4"
//]
