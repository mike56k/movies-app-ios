import SwiftUI
import UIKit
import AVKit

struct FilmUploadView: View {
    
    @StateObject var viewModel = FilmUploadViewModel()
    
    var body: some View {
        VStack {
            if player != nil {
                VideoPlayer(player: player!)
                    .frame(height: 300)
                    .onTapGesture {
                        self.isPlaying.toggle()
                        if self.isPlaying {
                            self.player?.play()
                        } else {
                            self.player?.pause()
                        }
                    }
            }
            Button("Select Video") {
                self.showVideoPicker = true
            }
            .sheet(isPresented: $showVideoPicker) {
                VideoPicker(videoURL: self.$videoURL, player: self.$player)
            }
        }
        .onChange(of: videoURL) { newValue in
            guard let videoURL = newValue else {
                return
            }
            
            Task {
                await viewModel.uploadTrailer(url: videoURL)
            }
        }
    }
    
    @State private var showVideoPicker = false
    @State private var videoURL: URL?
    @State private var player: AVPlayer?
    @State private var isPlaying = false
}

struct VideoPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var videoURL: URL?
    @Binding var player: AVPlayer?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [UTType.movie.identifier]
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: VideoPicker
        
        init(_ parent: VideoPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let url = info[.mediaURL] as? URL else {
                return
            }
            self.parent.videoURL = url
            self.parent.player = AVPlayer(url: url)
            self.parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
