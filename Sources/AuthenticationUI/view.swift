//	Created by Leopold Lemmermann on 27.10.22.

@_exported import AuthenticationService
import LeosMisc
import SwiftUI

@available(iOS 16, macOS 13, *)
public struct AuthenticationView: View {
  let service: any AuthenticationService

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
        MyAuthenticationView(service: service, isLoggedIn: $isLoggedIn, error: $error)
      }

      Divider()

      SiwAButton(service: service, isLoggedIn: $isLoggedIn, error: $error)
        .aspectRatio(8 / 1, contentMode: .fit)
        .frame(maxWidth: 400)
        .frame(maxWidth: .infinity)
    }
    .aspectRatio(1 / 1, contentMode: .fit)
    .buttonStyle(.borderedProminent)
    .textFieldStyle(.roundedBorder)
    .formStyle(.columns)
    .scrollContentBackground(.hidden)
    .padding()
    .alert(isPresented: Binding(optional: $error), error: error) {}
    .presentationDetents([.medium])
    #if os(iOS)
      .compactDismissButton()
    #endif
  }

  @State private var error: AuthenticationError?
  @State private var isLoggedIn = false

  public init?(service: any AuthenticationService) {
    if case .authenticated = service.status { return nil }
    self.service = service
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
