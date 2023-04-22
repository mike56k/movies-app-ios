import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

struct AuthView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(alignment: .leading) {
                    Text("Режим использования")
                        .font(.system(size: 22))
                        .fontWeight(.semibold)
                    
                    ForEach(Role.allCases) { role in
                        ActionButton(action: {
                            withAnimation {
                                viewModel.changeCurrentRole(newRole: role)
                            }
                        }, title: viewModel.titleForRole(role: role), style: makeAccent(ifCurrentRole: role))
                    }
                }
                
                if viewModel.currentRole != .guest {
                    authForm
                        .transition(.scale)
                }
            }
            .padding()
        }
        
    }
    
    private var authForm: some View {
        VStack(alignment: .leading) {
            Text("Авторизуйтесь в системе")
                .font(.system(size: 22))
                .fontWeight(.semibold)
            
            GoogleSignInButton(action: handleSignInButton)
        }
    }
    
    private func makeAccent(ifCurrentRole role: Role) -> ActionButton.ActionButtonStyle {
        return viewModel.currentRole == role ? .accent : .secondary
    }
    
    private func handleSignInButton() {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
          print("There is no root view controller!")
          return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            
            signInResult.user.refreshTokensIfNeeded { user, error in
                guard error == nil else { return }
                guard let user = user else { return }

                guard let idToken = user.idToken else { return }
//                tokenSignInExample(idToken: idToken.tokenString)
                print(idToken.tokenString)
            }
        }
    }
    
    private func tokenSignInExample(idToken: String) {
        guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else {
            return
        }

        let url = URL(string: "https://yourbackend.example.com/tokensignin")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            // Handle response from your backend.
        }
        task.resume()
    }
    
}