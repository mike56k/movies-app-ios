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
    let coverImageUrl: String?
    let trailerUrl: String?
}

struct Person: Decodable {
    let name: String
    let speciality: String
}


//{
//    "id": 233,
//    "name": "Счастливое число Слевина",
//    "engName": "Lucky Number Slevin",
//    "description": "Слевину не везет. Дом опечатан, девушка ушла к другому… Его друг Ник уезжает из Нью-Йорка и предлагает Слевину пожить в пустой квартире. В это время крупный криминальный авторитет по прозвищу Босс хочет рассчитаться со своим бывшим партнером за убийство сына и в отместку «заказать» его наследника.",
//    "yearOfRelease": 2005,
//    "rating": 0,
//    "length": 110,
//    "filmType": "movie",
//    "persons": [
//        {
//            "name": "Харольд Э. Коуп мл.",
//            "speciality": "actor"
//        }
//    ],
//    "genres": [
//        "триллер",
//        "драма",
//        "криминал"
//    ],
//    "countries": [
//        "США",
//        "Великобритания",
//        "Германия",
//        "Канада"
//    ]
//}
