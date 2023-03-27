import SwiftUI
import GoogleSignIn

@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    FilmsFeedView()
                }
                .tabItem {
                    Label("Фильмы", systemImage: "list.dash")
                }
                
                RootView()
                    .tabItem {
                        Label("Профиль", systemImage: "person.crop.circle")
                    }
            }
            .onAppear {
                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    guard let user = user else {
                        print("Error with restorePreviousSignIn!")
                        return
                    }
                }
            }
        }
    }
}
