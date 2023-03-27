struct FilmDetailsModel: Decodable {
    let id: Int
    let name: String
    let engName: String
    let description: String
    let yearOfRelease: Int
    let rating: Int
    let length: Int
    let filmType: FilmTypeModel
    let countries: [CountryModel]
    let mediaFiles: [MediaFileModel]
    let genres: [GenreModel]
//    let filmPeople: [FilmPersonModel]
}

struct FilmTypeModel: Decodable {
    let id: Int
    let name: String
}

struct CountryModel: Decodable {
    let id: Int
    let name: String
}

struct GenreModel: Decodable {
    let id: Int
    let name: String
}

struct MediaFileModel: Decodable {
    let id: Int
    let path: String
}

struct FilmPersonModel: Decodable {
    let person: PersonModel
    let speciality: SpecialityModel
}

struct SpecialityModel: Decodable {
    let id: Int
    let name: String
}

struct PersonModel: Decodable {
    let id: Int
    let name: String
    let growth: Int
    let dateBirth: String
    let dateDeath: String
    let birthPlace: String
    let genderId: Int
    let specialities: [SpecialityModel]
    let mediaFiles: [MediaFileModel]
}
