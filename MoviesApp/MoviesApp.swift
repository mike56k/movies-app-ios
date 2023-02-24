import SwiftUI

@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MoviesFeedView(films: [FilmFeedModel(id: 23,
                                                     name: "Счастливое число Слевина",
                                                     engName: "Lucky Number Slevin",
                                                     description: "Слевину не везет. Дом опечатан, девушка ушла к другому… Его друг Ник уезжает из Нью-Йорка и предлагает Слевину пожить в пустой квартире. В это время крупный криминальный авторитет по прозвищу Босс хочет рассчитаться со своим бывшим партнером за убийство сына и в отместку «заказать» его наследника.",
                                                     yearOfRelease: 2005,
                                                     rating: 0,
                                                     length: 110,
                                                     filmType: "movie",
                                                     persons: [
                                                        Person(name: "Харольд Э. Коуп мл.", speciality: "actor")
                                                     ],
                                                     genres: [
                                                         "триллер",
                                                         "драма",
                                                         "криминал"
                                                     ],
                                                     countries: ["США",
                                                                "Великобритания",
                                                                "Германия",
                                                                "Канада"],
                                                     coverImageUrl: "https://thumbs.dfs.ivi.ru/storage31/contents/a/9/23024854393c98cc6bd2de3fe0aeb2.jpg",
                                                     trailerUrl: "http://95.163.211.116/litvin.mp4"),
                                       FilmFeedModel(id: 233,
                                                                            name: "Хрен бобровый",
                                                                            engName: "Lucky Number Slevin",
                                                                            description: "Слевину не везет. Дом опечатан, девушка ушла к другому… Его друг Ник уезжает из Нью-Йорка и предлагает Слевину пожить в пустой квартире. В это время крупный криминальный авторитет по прозвищу Босс хочет рассчитаться со своим бывшим партнером за убийство сына и в отместку «заказать» его наследника.",
                                                                            yearOfRelease: 2005,
                                                                            rating: 8,
                                                                            length: 110,
                                                                            filmType: "movie",
                                                                            persons: [
                                                                                Person(name: "Харольд Э. Коуп мл.", speciality: "actor"),
                                                                                Person(name: "Бенжамин Бэкваоыв", speciality: "actor")
                                                                            ],
                                                                            genres: [
                                                                                "триллер",
                                                                                "драма",
                                                                                "криминал"
                                                                            ],
                                                                            countries: ["США",
                                                                                       "Великобритания",
                                                                                       "Германия",
                                                                                       "Канада"],
                                                                            coverImageUrl: "https://thumbs.dfs.ivi.ru/storage31/contents/a/9/23024854393c98cc6bd2de3fe0aeb2.jpg",
                                                                            trailerUrl: "http://95.163.211.116/litvin.mp4")])
            }
        }
    }
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
