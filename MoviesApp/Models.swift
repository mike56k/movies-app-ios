import Foundation

struct Film: Identifiable {
    let id: UUID = UUID()
    let name: String
    let alternativeName: String
    let description: String
    let yearOfRelease: Int
    let rating: Float
    let length: Int
    let coverImage: String
    let trailerUrl: String
    let genre: String
}

struct Actor {
    
}

struct Kinoko {
    
}

