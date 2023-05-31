// Created by Leopold Lemmermann on 14.12.22.

import Errors
import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct ChangePINView: View {
  let service: any AuthenticationService
  
  public var body: some View {
    VStack {
      Header(title: "CHANGE_PIN_TITLE", subtitle: "CHANGE_PIN_SUBTITLE")
      
      Divider()
      
      HStack {
        PINField(pin: $newPIN, prompt: String(localized: "NEW_PIN", bundle: .module))
          .textFieldStyle(.roundedBorder)
          .onSubmit {
            Task(priority: .userInitiated) { await changePIN() }
          }
        
        SendButton {
          await changePIN()
          return pinWasChanged
        }
        .buttonStyle(.borderedProminent)
        .disabled(confirmIsDisabledForPIN)
      }
      
      Divider()
      
      Text("SIWA_WARNING_PIN_CHANGE", bundle: .module)
        .bold()
        .multilineTextAlignment(.center)
        .foregroundColor(.red)
    }
    .alert(isPresented: Binding(item: $error), error: error) {}
    .presentationDetents([.medium])
    .padding()
    .disabled(pinWasChanged)
  }
  
  @State private var newPIN = ""
  @State private var pinWasChanged = false
  @State private var error: AuthenticationError?
  
  @Environment(\.dismiss) private var dismiss
  
  private var confirmIsDisabledForPIN: Bool { newPIN.count < 4 }
  
  public init(service: any AuthenticationService) {
    self.service = service
  }
  
  @MainActor private func changePIN() async {
    await printError {
      do {
        guard case .authenticated = service.status else { return }
        try await service.changePIN(newPIN)
        
        pinWasChanged = true
        dismiss()
      } catch let error as AuthenticationError where error.hasDescription { self.error = error }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
//@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
//struct ChangePINView_Previews: PreviewProvider {
//  static var previews: some View {
//    ChangePINView(service: .mock)
//
//    Text("")
//      .sheet(isPresented: .constant(true)) {
//        ChangePINView(service: .mock)
//      }
//      .previewDisplayName("Sheet")
//  }
//}
#endif
