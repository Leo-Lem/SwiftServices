//	Created by Leopold Lemmermann on 27.10.22.

import Concurrency
import CoreHapticsService
import LeosMisc
import SwiftUI

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
          .disableAutocorrection(true)

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

      SiwAButton(service: service)
        .aspectRatio(8 / 1, contentMode: .fit)
        .frame(maxWidth: 400)
        .frame(maxWidth: .infinity)
    }
    .buttonStyle(.borderedProminent)
    .textFieldStyle(.roundedBorder)
    .formStyle(.columns)
    .scrollContentBackground(.hidden)
    .padding()
    .presentationDetents([.medium])
    .alert(isPresented: Binding(optional: $error), error: error) {}
    .animation(.default, value: isAuthenticating)
    #if os(iOS)
      .overlay(alignment: .topTrailing) {
        if vSize == .compact {
          Button(String(localized: "CANCEL", bundle: .module)) { dismiss() }
            .buttonStyle(.borderedProminent)
            .padding()
        }
      }
    #endif
  }

  @Environment(\.dismiss) private var dismiss
  #if os(iOS)
    @Environment(\.verticalSizeClass) var vSize
  #endif

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
        AuthenticationView(service: .mock)
          .previewDisplayName("Bare")

        Text("")
          .sheet(isPresented: .constant(true)) {
            AuthenticationView(service: .mock)
          }
          .previewDisplayName("Sheet")
      }
    }
  }
#endif
