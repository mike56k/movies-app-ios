import SwiftUI

struct FilmCardView: View {
    let model: FilmFeedModel
    let gradient = Gradient(colors: [.purple, .cyan, .orange])

    var body: some View {
        HStack(spacing: 0) {
            Group {
                if let posterUrl = model.posterUrl {
                    AsyncImage(url: getPosterUrl(name: posterUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                }
                else {
                    Rectangle()
                        .fill(Color.gray)
                }
            }
            .frame(width: 80, height: 120)
            .cornerRadius(10)
            .clipped()
            .padding(.horizontal, 10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(model.name)
                    .fontWeight(.semibold)
                
                Text(model.engName + ", " + String(model.yearOfRelease) + ", \(model.length) мин.")
                    .font(.system(size: 14))
                
                Text("Рейтинг " + String(model.rating))
                    .foregroundColor(ratingColor(rating: model.rating))
                    .font(.system(size: 14))

                Text(model.genres.map { $0.capitalized }.joined(separator: ", "))
                    .fontWeight(.light)
                    .font(.system(size: 14))
                
                Text("В ролях: " + model.persons.map{ $0.name }.joined(separator: ", "))
                    .fontWeight(.thin)
                    .font(.system(size: 12))
                
                Spacer()
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .background(Color.Palette.cellBackground)
        .cornerRadius(20)
    }
    
    private func ratingColor(rating: Float) -> Color {
        if rating < 3.0 {
            return .gray
        }
        else if rating < 6.0 {
            return .yellow
        }
        else if rating < 8.0 {
            return .green
        }
        else {
            return .red
        }
    }
    
    private func getPosterUrl(name: String) -> URL? {
        return URL(string: "http://95.163.211.116:8001/" + (name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""))
    }
    
}
