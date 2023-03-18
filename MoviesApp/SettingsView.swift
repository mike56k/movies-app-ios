import SwiftUI

struct Filter: Identifiable {
    
    let name: String
    let options: [String]
    
    var id: String {
        return name
    }
    
}

struct SettingsView: View {
    let filters: [Filter] = [Filter(name: "Тип", options: ["Фильм", "Мультик", "Аниме"]), Filter(name: "Жанр", options: ["Мелодрамма", "Боевик", "Ужасы"])]
    
    var body: some View {
        VStack {
            Text("Фильтры")
                .fontWeight(.semibold)
                .padding()
            
            List {
                ForEach(filters, id: \.id) { filter in
                    Section {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(filter.options, id: \.self) { option in
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(Color.red)
                                        .overlay {
                                            Text(option)
                                        }
                                }
                            }
                        }
                    } header: {
                        Text(filter.name)
                    }
                }
            }
        }
        .background(Color.Palette.defaultBackground)
    }
    
}
