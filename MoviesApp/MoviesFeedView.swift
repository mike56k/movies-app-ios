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
                    Text(model.description)
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
                        Text(model.description)
                    }
                    
                    Spacer()
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
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
