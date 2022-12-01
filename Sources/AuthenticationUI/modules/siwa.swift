//	Created by Leopold Lemmermann on 27.11.22.

import AuthenticationServices
import Errors
import LeosMisc
import SwiftUI

@available(iOS 15, macOS 12, *)
public struct SiwAButton: View {
  let service: AuthenticationService
  @Binding var isLoggedIn: Bool
  @Binding var error: AuthenticationError?

  public var body: some View {
    SignInWithAppleButton(onRequest: handleRequest, onCompletion: handleCompletion)
      .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
      .if(isLoggedIn) { $0.colorMultiply(.gray) }
      .disabled(isLoggedIn)
  }

  @Environment(\.colorScheme) var colorScheme
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
            isLoggedIn = true
          } catch let error as AuthenticationError where error.hasDescription { self.error = error }
        }
      }
    case let .failure(error):
      printError { throw error }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  @available(iOS 16, macOS 13, *)
  struct SiwAButton_Previews: PreviewProvider {
    static var previews: some View {
      SiwAButton(
        service: .mock,
        isLoggedIn: .constant(false),
        error: .constant(nil)
      )
      .aspectRatio(8 / 1, contentMode: .fit)
    }
  }
#endif
