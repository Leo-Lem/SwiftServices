//	Created by Leopold Lemmermann on 27.10.22.

@_exported import AuthenticationService
import LeosMisc
import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct AuthenticationView: View {
  let service: any AuthenticationService

  public var body: some View {
    Form {
      Header(title: "AUTHENTICATION_TITLE", subtitle: "AUTHENTICATION_SUBTITLE")

      Divider()

      Section {
        EnterCredentialsView(service: service, isLoggedIn: $isLoggedIn, error: $error)
      }

      Divider()

      SiwAButton(service: service, isLoggedIn: $isLoggedIn, error: $error)
        .aspectRatio(8 / 1, contentMode: .fit)
        .frame(maxWidth: 400)
        .frame(maxWidth: .infinity)
    }
    .buttonStyle(.borderedProminent)
    .textFieldStyle(.roundedBorder)
    .formStyle(.columns)
    .scrollContentBackground(.hidden)
    .padding()
    .alert(isPresented: Binding(item: $error), error: error) {}
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
  @available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
  struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
      AuthenticationView(service: .mock)

      Text("")
        .sheet(isPresented: .constant(true)) {
          AuthenticationView(service: .mock)
        }
        .previewDisplayName("Sheet")
    }
  }
#endif
