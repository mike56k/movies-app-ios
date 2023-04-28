import SwiftUI

//struct PersonModel: Decodable {
//    let id: Int
//    let name: String
//    let growth: Int
//    let dateBirth: String?
//    let dateDeath: String?
//    let birthPlace: String
//    let gender: GenderModel
//    let specialities: [SpecialityModel]
//    let mediaFiles: [MediaFileModel]
//}

struct ActorCardView: View {
    
    enum Style {
        case small
        case big
    }
    
    let model: PersonModel
    let style: Style
    
    var body: some View {
        HStack(spacing: 10) {
            Group {
                if let photoUrl = model.mediaFiles.first {
                    AsyncImage(url: getActorPhotoUrl(name: photoUrl.path)) { image in
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
            
            VStack(alignment: .leading, spacing: 4) {
                if style == .small {
                    Spacer()
                }
                
                Text(model.name)
                    .fontWeight(.semibold)
                
                Text("Роль: " + model.specialities.map{ getSpeciality(speciality: $0) }.joined(separator: ", "))
                    .fontWeight(.thin)
                    .font(.system(size: 12))
                
                if style == .big {
                    if let dateBirth = getDate(date: model.dateBirth) {
                        Text("Дата рождения: " + dateBirth)
                            .fontWeight(.light)
                            .font(.system(size: 14))
                    }
                    
                    if let dateDeath = getDate(date: model.dateDeath) {
                        Text("Дата смерти: " + dateDeath)
                            .fontWeight(.light)
                            .font(.system(size: 14))
                    }
                    
                    if let growth = getGrowth(growth: model.growth) {
                        Text("Рост: " + growth)
                            .fontWeight(.thin)
                            .font(.system(size: 14))
                    }
                    
                    Text("Место рождения: \(model.birthPlace)")
                        .fontWeight(.thin)
                        .font(.system(size: 14))
                    
                    Text("Пол: " + getGender(genderModel: model.gender))
                        .fontWeight(.thin)
                        .font(.system(size: 14))
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 15)
    }
    
    private func getGender(genderModel: GenderModel) -> String {
        switch genderModel.value {
        case "male":
            return "Муж."
            
        case "female":
            return "Жен."
            
        default:
            return "Неизв."
        }
    }
    
    private func getSpeciality(speciality: SpecialityModel) -> String {
        switch speciality.name {
        case "actor":
            return "Актёр"
            
        case "director":
            return "Режисер"
            
        case "producer":
            return "Продюсер"
        
        default:
            return "-"
        }
    }
    
    private func getGrowth(growth: Int) -> String? {
        guard model.growth > 0 else {
            return nil
        }
        
        return "\(model.growth) см"
    }
    
    private func getDate(date: String?) -> String? {
        guard let date = date else {
            return nil
        }
        
        guard let date = dateFormatterRead.date(from: date) else {
            return nil
        }
        
        return dateFormatterWrite.string(from: date)
    }
    
    private let dateFormatterRead: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()
    
    private let dateFormatterWrite: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter
    }()
    
    private func getActorPhotoUrl(name: String) -> URL? {
        return URL(string: "http://95.163.211.116:8001/" + (name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""))
    }
    
}
