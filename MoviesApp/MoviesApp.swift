import SwiftUI

@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MoviesFeedView(viewModel: MoviesFeedViewModel(networkManager: NetworkManagerImpl()))
            }
        }
    }
}
