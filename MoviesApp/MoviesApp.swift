import SwiftUI
import GoogleSignIn

@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
//                RootView()
                FilmsFeedView()
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
