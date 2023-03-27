import SwiftUI
import UIKit
import AVKit

struct FilmUploadView: View {
    
    @StateObject var viewModel = FilmUploadViewModel()
    @State var name = ""
    @State var engName = ""
    @State var description = ""
    @State var selection: Int = 2023
    @State var length: String = ""
    
//    let name: String
//    let engName: String
//    let description: String
//    let yearOfRelease: Int
//    let length: Int
//    let filmTypeId: Int
//    let countriesIds: [Int]
//    let genresIds: [Int]
//    let personDTO: [PersonDTO]
    
    var body: some View {
        ScrollView {
            VStack {
                CustomTextField(input: $name, placeholder: "Название")
                CustomTextField(input: $engName, placeholder: "Оригинальное название")
                CustomTextField(input: $description, placeholder: "Описание")
                CustomTextField(input: $length, placeholder: "Продолжительность в мин.", accepts: .number)

                HStack {
                    Text("Год выпуска")
                    Picker("", selection: $selection) {
                        ForEach(yearsOptions, id: \.self) {
                            Text(String($0))
                        }
                    }
                }

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
                
                uploadTrailerButton
                    .sheet(isPresented: $showVideoPicker) {
                        VideoPicker(videoURL: self.$videoURL, player: self.$player)
                    }
                
                uploadFormButton
                Spacer()
            }
            .padding(20)
        }
        .navigationTitle("Добавление фильма")
    }
    
    @State private var showVideoPicker = false
    @State private var videoURL: URL?
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var yearsOptions = [Int](1920...2023)

    private var uploadTrailerButton: some View {
        Button {
            self.showVideoPicker = true
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .overlay {
                    HStack {
                        Text("Загрузить трейлер")
                        Image(systemName: "square.and.arrow.up")
                    }
                    .foregroundColor(.white)
                }
                .frame(minHeight: 50)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var uploadFormButton: some View {
        Button {
            guard let videoURL else {
                return
            }
            
            Task {
                await viewModel.uploadFilm(url: videoURL)
            }
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue)
                .overlay {
                    Text("Отправить")
                        .foregroundColor(.white)
                }
                .frame(minHeight: 50)
        }
        .buttonStyle(PlainButtonStyle())
    }
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
