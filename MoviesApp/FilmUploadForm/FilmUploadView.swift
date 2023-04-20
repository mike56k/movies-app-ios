import SwiftUI
import UIKit
import AVKit
import PhotosUI

struct FilmUploadView: View {
    
    @StateObject var viewModel = FilmUploadViewModel()
    
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
                CustomTextField(input: $viewModel.name, placeholder: "Название")
                CustomTextField(input: $viewModel.engName, placeholder: "Оригинальное название")
                CustomTextField(input: $viewModel.description, placeholder: "Описание")
                CustomTextField(input: $viewModel.length, placeholder: "Продолжительность в мин.", accepts: .number)

                HStack {
                    Text("Год выпуска")
                    Picker("", selection: $viewModel.yearOfRelease) {
                        ForEach(yearsOptions, id: \.self) {
                            Text(String($0))
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    if let image = viewModel.posterImage {
                        Text("Добавленная обложка")

                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: 300)
                            .clipped()
                            .cornerRadius(20)
                    }
                    
                    uploadPosterButton
                        .sheet(isPresented: $showSheet) {
                            ImagePicker(image: $viewModel.posterImage, videoURL: $viewModel.videoURL)
                        }
                }

                
                VStack(alignment: .leading) {
                    if let selectedVideoURL = viewModel.videoURL {
                        Text("Добавленный трейлер")

                        VideoPlayer(player: AVPlayer(url: selectedVideoURL))
                            .frame(height: 300)
                    }
                    
                    uploadTrailerButton
                        .sheet(isPresented: $showSheet) {
                            ImagePicker(image: $viewModel.posterImage, videoURL: $viewModel.videoURL)
                        }
                }
                
                uploadFormButton
                Spacer()
            }
            .padding(20)
        }
        .navigationTitle("Добавление фильма")
        .onAppear {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .videoChat, options: [.duckOthers,
                                                                                                        .defaultToSpeaker,
                                                                                                        .allowAirPlay,
                                                                                                        .allowBluetooth])
            } catch {
                print("Problems with sound")
            }
        }
    }
    
    @State private var showSheet = false
    @State private var isPlaying = false
    @State private var yearsOptions = [Int](1920...2023)
    
    private var uploadTrailerButton: some View {
        Button {
            self.showSheet = true
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .overlay {
                    HStack {
                        if viewModel.videoURL != nil {
                            Text("Обновить трейлер")
                        }
                        else {
                            Text("Загрузить трейлер")
                        }
                        Image(systemName: "square.and.arrow.up")
                    }
                    .foregroundColor(.white)
                }
                .frame(minHeight: 50)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var uploadPosterButton: some View {
        Button {
            self.showSheet = true
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .overlay {
                    HStack {
                        if viewModel.posterImage != nil {
                            Text("Обновить обложку")
                        }
                        else {
                            Text("Загрузить обложку")
                        }
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
            Task {
                await viewModel.uploadFilm()
            }
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue)
                .overlay {
                    if viewModel.isSending {
                        ProgressView()
                    }
                    else {
                        Text("Отправить")
                            .foregroundColor(.white)
                    }
                }
                .frame(minHeight: 50)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var videoURL: URL?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.images, .videos])
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true) {
                guard let result = results.first else { return }
                let prov = result.itemProvider
                if prov.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                    self.dealWithVideo(result)
                } else if prov.canLoadObject(ofClass: UIImage.self) {
                    self.dealWithImage(result)
                }
            }
        }
        
        private func dealWithVideo(_ result: PHPickerResult) {
            let movie = UTType.movie.identifier
            let prov = result.itemProvider
            prov.loadFileRepresentation(forTypeIdentifier: movie) { url, err in
                if let url = url {
                    let fileName = "\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)"
                    let newUrl = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
                    try? FileManager.default.copyItem(at: url, to: newUrl)
                    DispatchQueue.main.async {
                        self.parent.videoURL = newUrl
                    }
                }
            }
        }
        
        private func dealWithImage(_ result: PHPickerResult) {
            let prov = result.itemProvider
            prov.loadObject(ofClass: UIImage.self) { im, err in
                if let im = im as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.image = im
                    }
                }
            }
        }
    }
}
