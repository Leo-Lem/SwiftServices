//	Created by Leopold Lemmermann on 01.12.22.

import CoreHapticsService
import Errors
import SwiftUI

@available(iOS 16, macOS 13, *)
struct MyAuthenticationView: View {
  let service: AuthenticationService
  @Binding var isLoggedIn: Bool
  @Binding var error: AuthenticationError?

  var body: some View {
    Section {
      HStack {
        TextField(String(localized: "ENTER_USERID", bundle: .module), text: $credential.id)
          .autocorrectionDisabled()
          .onSubmit { if !confirmIsDisabledForID { checkUserIDExistence() } }
          .disabled(isShowingPINField)

        if isShowingPINField {
          if !isLoggedIn {
            Button { reset() } label: {
              Label(String(localized: "CANCEL", bundle: .module), systemImage: "xmark.circle")
            }
            .labelStyle(.iconOnly)
          }
        } else {
          sendButton(
            isLoading: isCheckingUserIDExistence,
            wasSuccessful: isShowingPINField,
            isDisabled: confirmIsDisabledForID
          ) { checkUserIDExistence() }
        }
      }

      if isShowingPINField {
        HStack {
          SecureField(String(localized: "ENTER_PIN", bundle: .module), text: $credential.pin)
            .autocorrectionDisabled()
            .onSubmit { if !confirmIsDisabledForPIN { loginOrRegister() } }
            .disabled(isLoggingInOrRegistering || isLoggedIn)

          sendButton(
            isLoading: isLoggingInOrRegistering,
            wasSuccessful: isLoggedIn,
            isDisabled: confirmIsDisabledForPIN
          ) { loginOrRegister() }
        }
      }
    }
    .animation(.default, value: isCheckingUserIDExistence)
    .animation(.default, value: isShowingPINField)
    .animation(.default, value: isLoggingInOrRegistering)
    .animation(.default, value: isLoggedIn)
    .alert(isPresented: Binding(optional: $error), error: error) {}
    .alert(String(localized: "UNKNOWN_USER_ID", bundle: .module), isPresented: $isShowingRegisterAlert) {
      Button { isShowingPINField = true } label: {
        Label(String(localized: "REGISTER", bundle: .module), systemImage: "person.badge.plus")
      }
      Button(String(localized: "CANCEL", bundle: .module)) {}
    } message: { Text("REGISTER_PROMPT", bundle: .module) }
  }

  @Environment(\.dismiss) private var dismiss

  @State private var credential = Credential(id: "", pin: "")

  @State private var userIDExists = false

  @State private var isShowingRegisterAlert = false
  @State private var isShowingPINField = false

  @State private var isCheckingUserIDExistence = false
  @State private var isLoggingInOrRegistering = false

  private let hapticsService = CoreHapticsService()
}

@available(iOS 16, macOS 13, *)
private extension MyAuthenticationView {
  func sendButton(isLoading: Bool, wasSuccessful: Bool, isDisabled: Bool, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      if isLoading {
        ProgressView()
      } else if wasSuccessful {
        Image(systemName: "checkmark.circle")
      } else {
        Label("\(Text("CONFIRM", bundle: .module))", systemImage: "paperplane")
      }
    }
    .labelStyle(.iconOnly)
    .disabled(isDisabled || wasSuccessful)
  }
}

@available(iOS 16, macOS 13, *)
private extension MyAuthenticationView {
  var confirmIsDisabledForID: Bool {
    credential.id.count < 4 ||
      credential.id.rangeOfCharacter(from: .alphanumerics.union(.punctuationCharacters).inverted) != nil
  }

  var confirmIsDisabledForPIN: Bool { credential.pin.count < 4 }

  @MainActor func reset() {
    credential = Credential(id: "", pin: "")
    userIDExists = false
    isShowingPINField = false
  }

  @MainActor func checkUserIDExistence() {
    Task(priority: .userInitiated) {
      do {
        isCheckingUserIDExistence = true

        userIDExists = try await service.exists(credential.id)
        
        if userIDExists {
          isShowingPINField = true
        } else {
          isShowingRegisterAlert = true
        }

      } catch let error as AuthenticationError where error.hasDescription { self.error = error }
      isCheckingUserIDExistence = false
    }
  }

  @MainActor func loginOrRegister() {
    Task(priority: .userInitiated) {
      do {
        isLoggingInOrRegistering = true

        _ = userIDExists ?
          try await service.login(credential) :
          try await service.register(credential)

        performLogin()
      } catch let error as AuthenticationError where error.hasDescription { self.error = error }
      isLoggingInOrRegistering = false
    }
  }

  func performLogin() {
    if case .authenticated = service.status {
      isLoggedIn = true
      hapticsService?.play(.taDa)
      dismiss()
    }
  }
}

// MARK: - (PREVIEWS)

@available(iOS 16, macOS 13, *)
struct MyAuthenticationView_Previews: PreviewProvider {
  static var previews: some View {
    Form {
      MyAuthenticationView(
        service: .mock,
        isLoggedIn: .constant(false),
        error: .constant(nil)
      )
    }
  }
}
