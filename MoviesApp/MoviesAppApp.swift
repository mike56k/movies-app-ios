import SwiftUI

@main
struct MoviesAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MoviesFeedView(films: [Film(name: "Masha&Medved", alternativeName: "Suka", description: "Bla bla", year: 1899, rating: 23, length: 70, coverImage: "https://play-lh.googleusercontent.com/eBmMygVthqyk1dhXul2OC9Hj831L3CSoTIM_FbmGFEY6mQZRnZGqghRHT5fX-hbrdg"),
                                               Film(name: "Masha&Medved", alternativeName: "Suka", description: "Bla bla", year: 1899, rating: 23, length: 70, coverImage: "https://play-lh.googleusercontent.com/eBmMygVthqyk1dhXul2OC9Hj831L3CSoTIM_FbmGFEY6mQZRnZGqghRHT5fX-hbrdg")])
            }
        }
    }
}
