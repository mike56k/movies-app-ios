import SwiftUI
import AVKit

struct TrailerPlayer: View {
    
    init(trailerUrl: URL) {
        _player = State(initialValue: AVPlayer(url: trailerUrl))
    }
    
    var body: some View {
        VideoPlayer(player: player)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
    
    @State private var player: AVPlayer
    
}
