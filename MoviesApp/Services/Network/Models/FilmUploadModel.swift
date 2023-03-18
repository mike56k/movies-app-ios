import Foundation

struct FilmUploadModel: Encodable {
    let name: String
    let engName: String
    let description: String
    let yearOfRelease: Int
    let length: Int
    let filmTypeId: Int
    let countriesIds: [Int]
    let genresIds: [Int]
    let personDTO: [PersonDTO]
}

struct PersonDTO: Encodable {
    let personId: Int
    let specialityId: Int
}
