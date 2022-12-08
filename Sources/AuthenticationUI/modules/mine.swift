//	Created by Leopold Lemmermann on 01.12.22.

import CoreHapticsService
import Errors
import LeosMisc
import SwiftUI

@available(iOS 16, macOS 13, *)
struct MyAuthenticationView: View {
  let service: any AuthenticationService
  @Binding var isLoggedIn: Bool
  @Binding var error: AuthenticationError?

  var body: some View {
    Section {
      HStack {
        TextField(String(localized: "ENTER_USERID", bundle: .module), text: $credential.id)
          .focused($focusedField, equals: .userID)
          .autocorrectionDisabled()
          .onSubmit {
            if !confirmIsDisabledForID {
              Task(priority: .userInitiated) { await checkUserIDExistence() }
            }
          }
          .disabled(isShowingPINField)

        if isShowingPINField {
          if !isLoggedIn {
            Button { reset() } label: {
              Label(String(localized: "CANCEL", bundle: .module), systemImage: "xmark.circle")
                .labelStyle(.iconOnly)
            }
          }
        } else {
          sendButton(wasSuccessful: isShowingPINField, isDisabled: confirmIsDisabledForID) {
            await checkUserIDExistence()
          }
        }
      }

      if isShowingPINField {
        HStack {
          SecureField(String(localized: "ENTER_PIN", bundle: .module), text: $credential.pin)
            .focused($focusedField, equals: .pin)
            .autocorrectionDisabled()
            .onSubmit {
              if !confirmIsDisabledForPIN {
                Task(priority: .userInitiated) { await loginOrRegister() }
              }
            }
            .disabled(isLoggedIn)

          sendButton(wasSuccessful: isLoggedIn, isDisabled: confirmIsDisabledForPIN) {
            await loginOrRegister()
          }
        }
      }
    }
    .animation(.default, value: isShowingPINField)
    .animation(.default, value: isLoggedIn)
    .alert(isPresented: Binding(item: $error), error: error) {}
    .alert(String(localized: "UNKNOWN_USER_ID", bundle: .module), isPresented: $isShowingRegisterAlert) {
      Button {
        isShowingPINField = true
        focusedField = .pin
      } label: {
        Label(String(localized: "REGISTER", bundle: .module), systemImage: "person.badge.plus")
      }
      Button(String(localized: "CANCEL", bundle: .module)) {}
    } message: { Text("REGISTER_PROMPT", bundle: .module) }
  }

  @State private var credential = Credential(id: "", pin: "")
  @State private var userIDExists = false
  @State private var isShowingRegisterAlert = false
  @State private var isShowingPINField = false

  @FocusState private var focusedField: Field?
  enum Field: Hashable { case userID, pin }

  @Environment(\.dismiss) private var dismiss
}

@available(iOS 16, macOS 13, *)
private extension MyAuthenticationView {
  func sendButton(wasSuccessful: Bool, isDisabled: Bool, action: @escaping () async -> Void) -> some View {
    AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated, action: action) {
      if wasSuccessful {
        Image(systemName: "checkmark.circle")
      } else {
        Label("\(Text("CONFIRM", bundle: .module))", systemImage: "paperplane")
          .labelStyle(.iconOnly)
      }
    }
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

  @MainActor func checkUserIDExistence() async {
    await printError {
      do {
        userIDExists = try await service.exists(credential.id)

        if userIDExists {
          isShowingPINField = true
          focusedField = .pin
        } else {
          isShowingRegisterAlert = true
        }
      } catch let error as AuthenticationError where error.hasDescription { self.error = error }
    }
  }

  @MainActor func loginOrRegister() async {
    await printError {
      do {
        _ = userIDExists ?
          try await service.login(credential) :
          try await service.register(credential)

        performLogin()
      } catch let error as AuthenticationError where error.hasDescription { self.error = error }
    }
  }

  func performLogin() {
    if case .authenticated = service.status {
      isLoggedIn = true
      CoreHapticsService()?.play(.taDa)
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
