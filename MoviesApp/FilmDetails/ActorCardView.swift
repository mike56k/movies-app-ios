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
    
    let model: PersonModel
    
    var body: some View {
        HStack(spacing: 0) {
            // TODO: Show actor photo
            
            VStack(alignment: .leading, spacing: 4) {
                Text(model.name)
                    .fontWeight(.semibold)
                
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
    
}
