import SwiftUI
import GoogleSignIn

@main
struct MoviesApp: App {
    @StateObject var roleManager = RoleManager()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    FilmsFeedView()
                }
                .tabItem {
                    Label("Фильмы", systemImage: "list.dash")
                }
                
                AuthView()
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
            .environmentObject(roleManager)
        }
    }
}
