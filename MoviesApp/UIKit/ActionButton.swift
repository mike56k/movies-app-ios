import SwiftUI

struct ActionButton: View {
    
    enum ActionButtonStyle {
        case accent
        case secondary
    }
    
    private let action: () -> Void
    private let title: String
    private let style: ActionButtonStyle
    private let imageName: String?
    private let isLoading: Bool
    
    init(action: @escaping () -> Void,
         title: String,
         style: ActionButtonStyle,
         imageName: String? = nil,
         isLoading: Bool = false) {
        self.action = action
        self.title = title
        self.style = style
        self.imageName = imageName
        self.isLoading = isLoading
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(style == .accent ? Color.blue : Color.gray)
                .overlay {
                    if isLoading {
                        ProgressView()
                    }
                    else {
                        HStack {
                            Text(title)
                            if let imageName = imageName {
                                Image(systemName: imageName)
                            }
                        }
                        .foregroundColor(.white)
                    }
                }
                .frame(minHeight: 50)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}

