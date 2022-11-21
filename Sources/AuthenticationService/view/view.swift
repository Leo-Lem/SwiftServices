//	Created by Leopold Lemmermann on 27.10.22.

import SwiftUI
import LeosMisc

@available(iOS 16, macOS 13, *)
public struct AuthenticationView: View {
  let service: AuthenticationService
  
  @Environment(\.dismiss) var dismiss
  
  public var body: some View {
    Form {
      Section {
        Text("TITLE")
          .bold()
          .font(.title)
          .frame(maxWidth: .infinity)
        
        Text("SUBTITLE")
          .font(.subheadline)
          .frame(maxWidth: .infinity)
      }

      Divider()

      Section {
        TextField("ENTER_USERID", text: $credential.id)
        
        HStack {
          SecureField("ENTER_PIN", text: $credential.pin)
          
          Button(action: startLogin) {
            Label("CONFIRM", systemImage: "paperplane")
          }
          .labelStyle(.iconOnly)
          .disabled(confirmDisabled)
        }
      }

      Divider()

      #if DEBUG
      // TODO: implement both of these
      Button {} label: {
        Label("SIWA", systemImage: "apple.logo")
          .frame(maxWidth: .infinity)
          .aspectRatio(8/1, contentMode: .fit)
      }

      Divider()
      
      Button {} label: {
        Label("SIWG", systemImage: "circles.hexagonpath.fill")
          .frame(maxWidth: .infinity)
          .aspectRatio(8/1, contentMode: .fit)
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
  }

  @State var credential = Credential(id: "", pin: "")
  
  @State var error: AuthenticationError?
  
  public init(service: AuthenticationService) { self.service = service }
}

@available(iOS 16, macOS 13, *)
extension AuthenticationView {
  var confirmDisabled: Bool {
    credential.id.count < 4 ||
      credential.id.rangeOfCharacter(from: .alphanumerics.union(.punctuationCharacters).inverted) != nil ||
      credential.pin.count < 4
  }
  
  func startLogin() {
    Task(priority: .userInitiated) {
      do {
        try await service.login(credential)
        
        if case .authenticated = service.status { dismiss() }
      } catch let error as AuthenticationError {
        switch error {
        case .noConnection, .registrationIDTaken, .registrationInvalidID, .authenticationWrongPIN:
          self.error = error
        default:
          print(error.localizedDescription)
        }
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
