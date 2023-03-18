import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

struct RootView: View {
    
    var body: some View {
        GoogleSignInButton(action: handleSignInButton)
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
