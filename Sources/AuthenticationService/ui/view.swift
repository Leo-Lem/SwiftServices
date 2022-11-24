//	Created by Leopold Lemmermann on 27.10.22.

// this is to prevent Github pipeline from failing (running macOS 12)
#if os(iOS)
import Concurrency
import LeosMisc
import SwiftUI
import CoreHapticsService

@available(iOS 16, macOS 13, *)
public struct AuthenticationView: View {
  let service: AuthenticationService

  public var body: some View {
    Form {
      Section {
        Text("TITLE", bundle: .module)
          .bold()
          .font(.title)
          .frame(maxWidth: .infinity)

        Text("SUBTITLE", bundle: .module)
          .font(.subheadline)
          .frame(maxWidth: .infinity)
      }

      Divider()

      Section {
        TextField("\(Text("ENTER_USERID", bundle: .module))", text: $credential.id)

        HStack {
          SecureField("\(Text("ENTER_PIN", bundle: .module))", text: $credential.pin)
            .onSubmit {
              if !confirmDisabled { startLogin() }
            }

          Button {
            startLogin()
          } label: {
            if isAuthenticating {
              ProgressView()
            } else if isAuthenticated {
              Image(systemName: "checkmark.circle")
            } else {
              Label("\(Text("CONFIRM", bundle: .module))", systemImage: "paperplane")
            }
          }
          .labelStyle(.iconOnly)
          .disabled(confirmDisabled)
        }
      }

      Divider()

      #if DEBUG
        Button {} label: {
          Label("\(Text("SIWA", bundle: .module))", systemImage: "apple.logo")
            .frame(maxWidth: .infinity)
            .aspectRatio(8 / 1, contentMode: .fit)
        }

        Divider()

        Button {} label: {
          Label("\(Text("SIWG", bundle: .module))", systemImage: "g.circle")
            .frame(maxWidth: .infinity)
            .aspectRatio(8 / 1, contentMode: .fit)
        }
      #endif
    }
    .buttonStyle(.borderedProminent)
    .textFieldStyle(.roundedBorder)
    .formStyle(.columns)
    .scrollContentBackground(.hidden)
    .padding()
    .presentationDetents([.medium])
    .alert(isPresented: Binding(optional: $error), error: error) {}
    .animation(.default, value: isAuthenticating)
  }

  @Environment(\.dismiss) var dismiss
  @State var credential = Credential(id: "", pin: "")
  @State var error: AuthenticationError.Display?

  @State private var isAuthenticating = false
  @State private var isAuthenticated = false
  
  private let hapticsService = CoreHapticsService()

  public init?(service: AuthenticationService) {
    if case .authenticated = service.status { return nil }
    self.service = service
  }
}

@available(iOS 16, macOS 13, *)
extension AuthenticationView {
  var confirmDisabled: Bool {
    credential.id.count < 4 ||
      credential.id.rangeOfCharacter(from: .alphanumerics.union(.punctuationCharacters).inverted) != nil ||
      credential.pin.count < 4 ||
      isAuthenticating ||
      isAuthenticated
  }

  @MainActor
  func startLogin() {
    Task(priority: .userInitiated) {
      do {
        isAuthenticating = true
        try await service.login(credential)
        isAuthenticating = false
        
        if case .authenticated = service.status {
          isAuthenticated = true
          hapticsService?.play(.taDa)
          dismiss()
        }
      } catch let error as AuthenticationError {
        self.error = error.display
        isAuthenticating = false
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  @available(iOS 16, macOS 13, *)
  struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        AuthenticationView(service: MockAuthenticationService())
          .previewDisplayName("Bare")

        Text("")
          .sheet(isPresented: .constant(true)) {
            AuthenticationView(service: MockAuthenticationService())
          }
          .previewDisplayName("Sheet")
      }
    }
  }
#endif
#endif
