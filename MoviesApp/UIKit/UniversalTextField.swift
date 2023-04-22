import SwiftUI
import Combine

struct UniversalTextField: View {
    
    enum Accepts {
        case text
        case number
    }
    
    init(input: Binding<String>, placeholder: String, accepts: Accepts = .text) {
        self.accepts = accepts
        self._input = input
        self.placeholder = placeholder
    }
    
    @Binding var input: String
    
    let placeholder: String
    let accepts: Accepts

    var body: some View {
        Group {
            switch accepts {
            case .text:
                TextField(placeholder, text: $input)
                
            case .number:
                TextField(placeholder, text: $input)
                    .keyboardType(.numberPad)
                    .onReceive(Just(input)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.input = filtered
                        }
                    }
            }
        }
        .frame(minHeight: 40)
        .padding(5)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black)
        )
    }
}
