import SwiftUI

struct CommentFormView: View {
    @Environment(\.presentationMode) var presentation
    @StateObject var viewModel: CommentFormViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $viewModel.commentText)
                if viewModel.commentText.isEmpty {
                    Text("Начните писать прямо здесь..")
                        .fontWeight(.bold)
                        .font(.system(size: 22))
                        .opacity(0.3)
                        .padding()
                }
            }
            VStack {
                HStack {
                    Text("Рейтинг \(Int(viewModel.rating))")
                    Slider(value: $viewModel.rating, in: 0...10, step: 1)
                }
                
                if !viewModel.commentText.isEmpty {
                    ActionButton(action: {
                        Task {
                            let success = await viewModel.sendComment()
                            if success {
                                presentation.wrappedValue.dismiss()
                            }
                        }
                    }, title: "Отправить", style: .accent)
                    .frame(height: 50)
                }
            }
        }
        .animation(.default, value: viewModel.commentText.isEmpty)
        .padding()
    }
    
}
