import Foundation

struct FilmFeedModel: Identifiable, Decodable {
    let id: Int
    let name: String
    let engName: String
    let description: String
    let yearOfRelease: Int
    let rating: Float
    let length: Int
    let filmType: String
    let persons: [Person]
    let genres: [String]
    let countries: [String]
    let posterUrl: String?
    let trailerUrl: String?
}

struct Person: Decodable {
    let name: String
    let speciality: String
}
