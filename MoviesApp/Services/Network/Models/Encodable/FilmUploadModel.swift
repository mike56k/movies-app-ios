import Foundation

struct FilmUploadModel: Encodable {
    let name: String
    let engName: String
    let description: String
    let yearOfRelease: Int
    let length: Int
    let trailerFileName: String
    let poster: Poster
    let filmTypeId: Int
    let countriesIds: [Int]
    let genresIds: [Int]
    let personDTO: [PersonDTO]
    let filmImages: [Poster]
}

struct PersonDTO: Encodable {
    let personId: Int
    let specialityId: Int
}

struct Poster: Encodable {
    let imageBase64: String
    let `extension`: String
}
