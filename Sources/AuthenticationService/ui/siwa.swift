//	Created by Leopold Lemmermann on 27.11.22.

import AuthenticationServices
import Errors
import LeosMisc
import SwiftUI

@available(iOS 15, macOS 12, *)
public struct SiwAButton: View {
  let service: AuthenticationService

  public var body: some View {
    SignInWithAppleButton(onRequest: handleRequest, onCompletion: handleCompletion)
      .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
      .alert(isPresented: Binding(optional: $error), error: error) {}
  }

  @Environment(\.colorScheme) var colorScheme
  @State private var error: AuthenticationError.Display?
}

@available(iOS 15, macOS 12, *)
extension SiwAButton {
  func handleRequest(_: ASAuthorizationAppleIDRequest) {}

  func handleCompletion(_ result: Result<ASAuthorization, Error>) {
    switch result {
    case let .success(auth):
      guard let appleID = auth.credential as? ASAuthorizationAppleIDCredential else { return }

      Task(priority: .userInitiated) {
        await printError {
          do {
            try await service.login(Credential(id: appleID.user, pin: ""))
          } catch let error as AuthenticationError {
            self.error = error.display
          }
        }
      }
    case let .failure(error):
      printError { throw error }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
@available(iOS 15, macOS 12, *)
struct SiwAButton_Previews: PreviewProvider {
  static var previews: some View {
    SiwAButton(service: .mock)
      .aspectRatio(6/1, contentMode: .fit)
  }
}
#endif
