import SwiftUI

@main
struct MoviesAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MoviesFeedView(films: [Film(name: "Masha&Medved", alternativeName: "Masha crazy movie 2112", description: "«Ма́ша и Медве́дь» — российский мультипликационный сериал, созданный анимационной студией «Анимаккорд», ориентированный на общую аудиторию. Показ начался 7 января 2009 года. Мультфильм создан при помощи трёхмерной графики. Транслируется на телевизионных каналах «Карусель», «Мульт», «Суббота» и других.", yearOfRelease: 1899, rating: 23, length: 70, coverImage: "https://play-lh.googleusercontent.com/eBmMygVthqyk1dhXul2OC9Hj831L3CSoTIM_FbmGFEY6mQZRnZGqghRHT5fX-hbrdg", trailerUrl: "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")])
            }
        }
    }
}
