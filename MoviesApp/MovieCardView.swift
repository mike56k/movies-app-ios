import SwiftUI

struct MovieCardView: View {
    let model: Film
    let gradient = Gradient(colors: [.purple, .cyan, .orange])

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: model.coverImage)) { image in
                ZStack(alignment: .bottom) {
                    image
                        .resizable()
                        .scaledToFill()
                    
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.clear, .cellBackground]), startPoint: .top, endPoint: .bottom))
                        .frame(height: 150)
                }
            } placeholder: {
                ProgressView()
            }
            .frame(height: 230)
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
